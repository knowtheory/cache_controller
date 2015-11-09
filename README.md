# cache\_controller

This is a sinatra app built to investigate cache controlling with nginx.

## Notes

DocumentCloud currently uses page caching in order to write resource bodies (notes, documents, search requests) to disk so that nginx can serve resources statically.

The lifecycle for each of these cached resources is controlled by 

### Open questions

- Can resources be cached conditionally?
    - If so, can they be expired?
    - If they can't be expired, can they be upserted?
- Can we ensure that cached content is target correctly and nobody ever gets content cached for someone else.


### Bibliography

* http://www.mobify.com/blog/beginners-guide-to-http-cache-headers/
* https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en
* https://mattbrictson.com/nginx-reverse-proxy-cache
* http://www.sinatrarb.com/intro.html
* http://recipes.sinatrarb.com/p/middleware/rack_commonlogger
* http://www.rubydoc.info/github/rack/rack/Rack/ETag
* https://www.nginx.com/blog/nginx-caching-guide/
