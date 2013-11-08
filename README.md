xslt-for-ogc-services
=====================

XSLT style sheets to convert OGC service responses (like GetCapabilities) into a human readable format

Demo: [WMTS](http://opencache.statkart.no/gatekeeper/gk/gk.open_wmts?Version=1.0.0&service=wmts&request=getcapabilities) [WMS](http://opencache.statkart.no/gatekeeper/gk/gk.open?Version=1.0.0&service=wms&request=getcapabilities)

Map services that follow the OGC standards are often called «self-descriptive». That means that they answer a GetCapabilities request with their metadata in XML. This metadata should be all you need to create a view of the service offered.

That is not exactly a human readable documentation. Fortunately, modern browsers support XSLT stylesheets, which transform XML documents. If you use these style sheets, you can transform the metadata, for example, into a web site. The documentation pages we offer this way will display both the most important settings you need for the service, and a simple map client to preview the service. Changes in the service configuration will update the XML, which again updates the documentation – fully automatic. 

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

