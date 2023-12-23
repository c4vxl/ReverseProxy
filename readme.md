# Reverse Proxy
This Bash script allows you to set up a reverse proxy using Nginx, with options for HTTP, HTTPS, and stream configurations.

## Usage
1. Clone the `proxy.sh` file to your operating system.
2. Make sure your Domain points to the device this Script is running on
3. run the script
4. Follow the on-screen prompts to configure the reverse proxy.

## Configuration Options
- Domain: The domain for which the reverse proxy should be configured.
- Forward domain: The server to which the connections should be forwarded.
- Port to listen to: The port on which the reverse proxy should listen.
- Type:
    - [1] HTTP: Configure a basic HTTP reverse proxy.
    - [2] HTTPS: Configure an HTTPS reverse proxy.
    - [3] STREAM: Configure a stream reverse proxy.



## License

This project is licensed under the [MIT License](LICENSE).

---

## Developer
This Project was Developed by [c4vxl](https://c4vxl.de)

<br><br>

_Note: Ensure that you have the necessary permissions and have reviewed the generated Nginx configurations before deploying this script in a production environment._