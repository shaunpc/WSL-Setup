import requests
from bs4 import BeautifulSoup

print("Determining latest KAFKA version for download...")

# First for the version directory
url = "https://downloads.apache.org/kafka"

# Send an HTTP GET request to the URL
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:

    # Parse the HTML content with BeautifulSoup
    soup = BeautifulSoup(response.text, 'html.parser')
   
    # Extract the text within the all the  <a> tags that contain "/"
    a_texts = [a.text for a in soup.find_all('a') if '/' in a.text]

    # Exatrct just the directory name
    version = max(a_texts).rstrip("/")
    url = url + "/" + version

    # Send an HTTP GET request to the URL
    response = requests.get(url)

    # Check if the request was successful (status code 200)
    if response.status_code == 200:

        # Parse the HTML content with BeautifulSoup
        soup = BeautifulSoup(response.text, 'html.parser')

        file = version + ".tgz"

        # Extract the text within the all the  <a> tags that contain "/"
        a_texts = [a.text for a in soup.find_all('a') if a.text.endswith(file)]

        latest = max(a_texts)

        kafka_vsn_full = url + "/" + latest
        kafka_vsn_short = latest[:-4]

        f = open("kafka-version.sh", "w")
        f.write('KAFKA_VSN_FULL="'+kafka_vsn_full+'"\n')
        f.write('KAFKA_VSN_SHORT="'+kafka_vsn_short+'"\n')
        f.close()

