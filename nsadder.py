import urllib
import urllib2
apikey      = ''
url = 'http://ns.example.com/'



print "Input HostName:(.example.com)"
host = raw_input()
print "Input IP Address"
ip = raw_input()
print host + " : " + ip + "  OK? [Y/n]"
confirm = raw_input()

if (confirm == "" or confirm =="Y"):
	values = {'ip' : ip,'host' : host ,'mode':'add', "apikey" : apikey}
	data = urllib.urlencode(values)
	req = urllib2.Request(url,data)
        try:
            response = urllib2.urlopen(req)
        except urllib2.URLError, e:
            if hasattr(e, 'reason'):
                print 'We failed to reach a server.'
                print 'Reason: ', e.reason
            elif hasattr(e, 'code'):
                print 'The server couldn\'t fulfill the request.'
                print 'Error code: ', e.code
        else:
            print response.read()
