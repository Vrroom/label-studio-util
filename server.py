import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

class CORSRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        return super().end_headers()

if __name__ == '__main__':
    if len(sys.argv) > 1:
        PORT = int(sys.argv[1])
    else:
        PORT = 7860  # Default port if not specified
    
    httpd = HTTPServer(('0.0.0.0', PORT), CORSRequestHandler)
    print(f"Serving at port {PORT}")
    httpd.serve_forever()
