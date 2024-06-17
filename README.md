It is my first HA add-on. Thank [Kjell Hanken](https://github.com/kjell5317/addon-ddns) and 
[SJ Chou](https://github.com/samejack/blog-content/blob/master/ddns/cf-ip-renew.sh), 
Referencing their sample allowed me to complete this add-on.  
__run.sh__: Reference [SJ Chou](https://github.com/samejack)'s [cf-ip-renew.sh](https://github.com/samejack/blog-content/blob/master/ddns/cf-ip-renew.sh).  
Other details: Reference [Kjell Hanken](https://github.com/kjell5317/addon-ddns)'s project to make a HA add-on.

This add-on is used to automatically update Cloudflare's dns records with your latest public ip address.

## Installation

Go to the add-on store of the supervisor and click on _repositories_ under the three dots.
Copy [_https://github.com/Maboroshi0327/cloudflare_ddns_updater_](https://github.com/Maboroshi0327/cloudflare_ddns_updater) 
into the field and add this repository.
Now you can install this add-on like any other home-assistant add-on.

## Configuration

1. Create an `API token` at [Cloudflare](https://dash.cloudflare.com/profile/api-tokens) and give it _Zone.DNS_ permissions.
2. Please refer to this [tutorial](https://blog.toright.com/posts/7333/cloudflare-ddns) to obtain the `Zone ID` and `Record ID`.
3. Enter these details into the add-on's settings page and start it.  
   Your configuration should look similar to this:

```yaml
DNS: maboroshi.idv.tw
CF_TOKEN: <YOUR_API_TOKEN>
CF_ZONE_ID: <YOUR_ZONE_ID>
CF_RECORD_ID: <YOUR_RECORD_ID>
proxied: false
time: 300
```