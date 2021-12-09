require 'pry'
require 'json'
require 'domainatrix'

class Opportunity < ApplicationRecord

    self.primary_key = "id"
    belongs_to :source
    
    def add_source

        if self.job_url.include?(' ')
            self.job_url="http://www.google.com"
        end
        if self.job_url=="http://"
            self.job_url="http://www.google.com"
        end

        domains = Source.all.map{|s| Domainatrix.parse(s.root_domain)}
        my_url = Domainatrix.parse(self.job_url)
        domain = my_url.domain
        stripped = domains.map{|d| d.domain}

        if stripped.include?(domain)
            source = Source.all.select{|s| s.root_domain.include?(domain)}
            self.source = source[0]
        elsif domain.include?(self.company_name.downcase.gsub(/\s+/, "")) 
            self.source = Source.find(1)
        else
            self.source = Source.find(2)   
        end
        
        self.save
    end

end