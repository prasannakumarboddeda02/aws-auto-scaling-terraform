from multiprocessing import Pool
from requests import get, exceptions

DOMAIN = 'lb-625911287.ap-south-1.elb.amazonaws.com'

def send_request(_):
    while True:
        try:
            response = get(f'http://{DOMAIN}', timeout=3)

            if response.headers.get('Content-Type', '').startswith('application/json'):
                print(response.json())
            else:
                print(response.status_code, response.text[:100])

        except exceptions.RequestException as e:
            print("Request failed:", e)

if __name__ == '__main__':
    with Pool(150) as p:
        p.map(send_request, range(150))
