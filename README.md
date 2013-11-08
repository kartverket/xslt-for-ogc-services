xslt-for-ogc-services
=====================

XSLT style sheets to convert OGC service responses (like GetCapabilities) into a human readable format

Currently, the following style sheets are available:
* WMS 1.1.1
* WMS 1.3.0
* WMTS 

The style sheets make use of an external map client like OpenLayers. You may have to tweak your style sheet to match your client.

YMMV - In our case, the map client listens to the URL 

    http://labs.kartverket.no/norgeskart/wmts.html?id={layerid}&url={serviceurl}&name={servicename}&layer={layername}

To make your map or cache server use the XSLT style sheets, you will have to make him send the header 

    <?xml-stylesheet type="text/xsl" href="/xslt/WMTSGetCapabilities.xsl" ?>
    
with the request. You can find a patch for geowebcache in our repositories here:

* https://github.com/kartverket/geowebcache (3f512c00cf6057a0bb1a591e0ae3c1215e0bfe52 and 4ac70cfdd04f6065ed72412f3be45b918a5d8c6a)

