class Contacts
  class Onelt < Base
    LOGIN_URL = "http://w33.one.lt/logonSubsite.do?subsite=pastas"
    ADDRESS_BOOK_URL = "http://email.one.lt/index.html?screen=RedirectServer&pane=contacts"
    PROTOCOL_ERROR = "One.lt has changed its protocols, please upgrade this library first. If that does not work, report this error at http://rubyforge.org/forum/?group_id=2693"

    attr_accessor :cookies

    def real_connect
      postdata =  "subsite=pastas&username=%s&password=%s" % [
        CGI.escape(username),
        CGI.escape(password)
      ]

      data, resp, self.cookies, forward, old_url = post(LOGIN_URL, postdata, "")

      if data.index("f-login")
        raise AuthenticationError, "Username and password do not match"
      elsif !cookies.match('JSESSIONID')
        raise ConnectionError, PROTOCOL_ERROR
      end

      data, resp, self.cookies, forward, old_url = post(forward, postdata, self.cookies)
      p forward
      until forward.nil?
        data, resp, self.cookies, forward, old_url = get(forward, self.cookies, old_url) + [forward]
      end

      p data
    end

    def contacts
      data, resp, cookies, forward = get(ADDRESS_BOOK_URL, self.cookies)


      []
    end

    private

    def username
      login.split('@').first
    end

  end

  TYPES[:onelt] = Onelt
end