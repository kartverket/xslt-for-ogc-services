xslt-for-ogc-services
=====================

XSLT style sheets to convert OGC service responses (like GetCapabilities) into a human readable format

Demo: [WMTS](http://opencache.statkart.no/gatekeeper/gk/gk.open_wmts?Version=1.0.0&service=wmts&request=getcapabilities) [WMS](http://opencache.statkart.no/gatekeeper/gk/gk.open?Version=1.0.0&service=wms&request=getcapabilities)

Currently, the following style sheets are available:
* WMS 1.1.1 (downwards compatible) GetCapabilities
* WMS 1.3.0 GetCapabilities
* WMTS GetCapabilities

The style sheets make use of an external map client like OpenLayers. You may have to tweak your style sheet to match your client.

YMMV - In our case, the map client listens to the URL 

    http://labs.kartverket.no/norgeskart/wmts.html?id={layerid}&url={serviceurl}&name={servicename}&layer={layername}

To make your map or cache server use the XSLT style sheets, you will have to make him send the header 

    <?xml-stylesheet type="text/xsl" href="/xslt/WMTSGetCapabilities.xsl" ?>
    
with the response. You can find a patch for geowebcache in our repositories here:

* https://github.com/kartverket/geowebcache (https://github.com/kartverket/geowebcache/commits?author=relet)

