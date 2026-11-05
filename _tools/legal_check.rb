#!/usr/bin/env ruby
# frozen_string_literal: true

# Έλεγχος των νομικών κειμένων (Ευαγγέλιο 5.1, 5.2, 5.4). Τρέχει πριν από κάθε push που αγγίζει <slug>/privacy-*.html ή terms-*.html:
#
#   ruby _tools/legal_check.rb
#
# Για κάθε εφαρμογή με has_legal: true στο _data/apps.yml ελέγχει ότι:
#   - υπάρχουν και τα τέσσερα αρχεία (privacy/terms, el/en),
#   - φορτώνουν ΜΟΝΟ το /assets/legal.css (καθόλου <style> ή άλλο stylesheet),
#   - η «Τελευταία ενημέρωση» είναι ίδια στα el και en του ίδιου κειμένου,
#   - το email επικοινωνίας είναι το support_email της εφαρμογής,
#   - και αντίστροφα: κάθε φάκελος με νομικά έχει has_legal: true.
# Δεν ελέγχει το περιεχόμενο (αυτό γίνεται με τη λίστα του CLAUDE.md → «Πότε αλλάζουν τα νομικά»).

require 'yaml'
require 'date'

ROOT = File.expand_path('..', __dir__)
GREEK_MONTHS = %w[Ιανουαρίου Φεβρουαρίου Μαρτίου Απριλίου Μαΐου Ιουνίου Ιουλίου Αυγούστου Σεπτεμβρίου Οκτωβρίου Νοεμβρίου Δεκεμβρίου].freeze
ENGLISH_MONTHS = Date::MONTHNAMES.compact.freeze

def parse_date(text, lang)
  if lang == 'el'
    m = text.match(/Τελευταία ενημέρωση:\s*(\d{1,2})\s+(\S+)\s+(\d{4})/)
    return nil unless m && (i = GREEK_MONTHS.index(m[2]))
    Date.new(m[3].to_i, i + 1, m[1].to_i)
  else
    # «November 5, 2026» ή «5 November 2026»
    if (m = text.match(/Last updated:\s*(\w+)\s+(\d{1,2}),\s*(\d{4})/))
      return nil unless (i = ENGLISH_MONTHS.index(m[1]))
      Date.new(m[3].to_i, i + 1, m[2].to_i)
    elsif (m = text.match(/Last updated:\s*(\d{1,2})\s+(\w+)\s+(\d{4})/))
      return nil unless (i = ENGLISH_MONTHS.index(m[2]))
      Date.new(m[3].to_i, i + 1, m[1].to_i)
    end
  end
end

apps = YAML.load_file(File.join(ROOT, '_data', 'apps.yml'))
apps = apps['list'] if apps.is_a?(Hash)
errors = []
declared = []

apps.each do |app|
  next unless app['has_legal']
  slug = app['slug']
  declared << slug
  email = app['support_email']
  %w[privacy terms].each do |kind|
    dates = {}
    %w[el en].each do |lang|
      rel = "#{slug}/#{kind}-#{lang}.html"
      path = File.join(ROOT, rel)
      unless File.exist?(path)
        errors << "#{rel}: λείπει"
        next
      end
      html = File.read(path, encoding: 'UTF-8')
      errors << "#{rel}: πρέπει να φορτώνει το /assets/legal.css" unless html.include?('href="/assets/legal.css"')
      errors << "#{rel}: δεν επιτρέπεται <style> μέσα στη σελίδα" if html =~ /<style/i
      errors << "#{rel}: άλλο stylesheet εκτός του legal.css" if html.scan(/<link[^>]+stylesheet[^>]+>/i).any? { |l| !l.include?('/assets/legal.css') }
      errors << "#{rel}: δεν βρέθηκε το email #{email}" if email && !html.include?("mailto:#{email}")
      dates[lang] = parse_date(html, lang)
      errors << "#{rel}: δεν διαβάζεται η «Τελευταία ενημέρωση»" unless dates[lang]
    end
    if dates['el'] && dates['en'] && dates['el'] != dates['en']
      errors << "#{slug}/#{kind}: διαφορετική ημερομηνία el (#{dates['el']}) και en (#{dates['en']})"
    end
  end
end

Dir.glob(File.join(ROOT, '*', 'privacy-el.html')).each do |p|
  slug = File.basename(File.dirname(p))
  errors << "#{slug}/: έχει νομικά αλλά has_legal δεν είναι true στο _data/apps.yml" unless declared.include?(slug)
end

if errors.empty?
  puts "OK: νομικά κείμενα ελεγμένα για #{declared.sort.join(', ')}"
else
  puts errors
  exit 1
end
