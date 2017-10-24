1. What is the difference between a session and a session token?

The web app creates a session for each user in order to process the series of request that originate from each unique user.  
The session = set of data structures held on the server in order to track the state of the users interaction with the web app  
The token = unique string that  identifies a session  

2. Identification Authentification Authorization ? 

Identification happens before atuhentification, and is the process of having user to indetify themself to the system (e.g username)
Authenticating a user involves establishing that the user is in fact who he claims to be (e.g the verification of the identity be the specification of a password)
Authorization reprezents what the user can access on the system.

3. HTTP GET vs POST vs PUT methods ?  

GET = retrieves resources from the server, it can be used to send parameters to the requested resource in the URL query string. Get request it is cacheble by the server (same request for the same resource by the same client). (ReadMethod)  

POST = used to perform actions (resource creation request) , the request parameters can be sent in both in URL and in the body of the message. (Resend or Leave Page - browsers do not reissue POST request)(WriteMethod) . Cannot be repeated safely so it is not idempotent  

PUT = it is idempotent(can be reapeated) (update resource request)

4. ARP Spoofing?
Address Resolution Protocol (layer 2 protocol) used to map ip addr with MAC addr. ARP does not provide a method to authenthificate ARP Replys, so the spoofer 

5. IP classes clasification?

Class A: 1-127 (first octet), 255.0.0.0 (mask), 1677216 hosts -2 reserved addr (network id and broadcast)
Class B: 128-191 (first octet), 255.255.0.0 (mask), 65536 hosts -2
Class C: 192-223 (first octet) 255.255.255.0, 254 host per network


