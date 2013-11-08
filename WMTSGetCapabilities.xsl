<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:wmts="http://www.opengis.net/wmts/1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ows="http://www.opengis.net/ows/1.1">
<!-- an XSLT stylesheet to display WMTS GetCapabilities calls -->
<!-- by Kartverket/Thomas Hirsch 2012 - Public Domain    -->

<xsl:output method="html" />

<xsl:template name="string-replace-all">
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text,$replace)" />
      <xsl:value-of select="$by" />
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text"
        select="substring-after($text,$replace)" />
        <xsl:with-param name="replace" select="$replace" />
        <xsl:with-param name="by" select="$by" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="wmts:Capabilities">
   <html>
   <head>
     <title><xsl:value-of select="ows:ServiceIdentification/ows:Title"/> [GetCapabilities]</title>
   </head>
   <body>
     <div>
         <table>
           <tr><td><b>Service:</b></td><td><b><xsl:value-of select="ows:ServiceIdentification/ows:Title"/></b></td></tr>
           <tr><td>Type:</td><td><xsl:value-of select="ows:ServiceIdentification/ows:ServiceType"/>&#160;<xsl:value-of select="ows:ServiceIdentification/ows:ServiceTypeVersion"/>
           </td></tr>
           <tr><td>Provider:</td><td>
             <xsl:element name="a">
               <xsl:attribute name="href"><xsl:value-of select="ows:ServiceProvider/ows:ProviderSite/@*[local-name()='href']"/></xsl:attribute>
               <xsl:value-of select="ows:ServiceProvider/ows:ProviderName"/>
             </xsl:element>
           </td></tr>
           <tr><td colspan="2"><hr/></td></tr>
           <tr><td>Contact:</td><td><xsl:apply-templates select="ows:ServiceProvider/ows:ServiceContact"/></td></tr>
           <tr><td>Access:</td><td><xsl:value-of select="ows:ServiceIdentification/ows:AccessConstraints"/></td></tr>
           <tr><td>Fees:</td><td><xsl:value-of select="ows:ServiceIdentification/ows:Fees"/></td></tr>
           <tr><td colspan="2"><hr/></td></tr>
         </table>
     </div>
     <xsl:for-each select="ows:OperationsMetadata">
       <table>
         <tr><td>Supported methods:</td><td>
            <ul>
            <xsl:for-each select="ows:Operation">
              <li><b><xsl:value-of select="@name"/>: </b> 
              <xsl:for-each select="ows:DCP">
                <xsl:for-each select="*">
                  <xsl:value-of select="local-name(.)"/>&#160; 
                  <xsl:for-each select="*">
                    <xsl:element name="a">
                      <xsl:attribute name="href"><xsl:value-of select="./@*[local-name()='href']"/></xsl:attribute>
                      <xsl:value-of select="local-name(.)"/>
                    </xsl:element>; 
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each></li>
            </xsl:for-each>
            </ul>
         </td></tr>
       </table>
     </xsl:for-each>
     <div><h2>Layers</h2></div>
     <xsl:apply-templates select="wmts:Contents/wmts:Layer"/>
   </body>
   </html>
</xsl:template>

<xsl:template name="selectScale">
  5 <!-- no scale hints in WMTS -->
</xsl:template>

<xsl:template match="wmts:Layer">
  <xsl:variable name="url">
	<xsl:call-template name="string-replace-all">
		<xsl:with-param name="text" select="//ows:OperationsMetadata/ows:Operation/ows:DCP/ows:HTTP/ows:Get/@*[local-name()='href']" />
		<xsl:with-param name="replace" select="'cacheserver:8080/geowebcache/service/wmts'" />
		<xsl:with-param name="by" select="'opencache.statkart.no/gatekeeper/gk/gk.open_wmts'" />		
	</xsl:call-template>
  </xsl:variable>
  <xsl:variable name="client">
    http://labs.kartverket.no/norgeskart/wmts.html?id=<xsl:value-of select="ows:Title"/>&amp;url=<xsl:value-of select="$url"/>&amp;name=<xsl:value-of select="ows:Title"/>&amp;layer=<xsl:value-of select="ows:Identifier"/><xsl:if test="not(wmts:TileMatrixSetLink[wmts:TileMatrixSet='EPSG:32633'])">&amp;proj=<xsl:value-of select="substring(wmts:TileMatrixSetLink/wmts:TileMatrixSet,6)"/></xsl:if>#<xsl:call-template name="selectScale"/>/189721/6833548/wlh
  </xsl:variable>

  <div style="border:1px solid green;">
  <div style="background-color:#dfd; padding:5px"><b>
  <xsl:value-of select="ows:Title"/></b> - 
         <xsl:element name="a">
           <xsl:attribute name="href"><xsl:value-of select="$client"/></xsl:attribute>
           <xsl:value-of select="'Map client'"/>
         </xsl:element>
       </div>
       <xsl:if test="../../wmts:Contents">
       <table><tr><td>
         <xsl:element name="iframe">
           <xsl:attribute name="width">640</xsl:attribute>
           <xsl:attribute name="height">480</xsl:attribute>
           <xsl:attribute name="scrolling">no</xsl:attribute>
           <xsl:attribute name="frameborder">0</xsl:attribute>
           <xsl:attribute name="src"><xsl:value-of select="$client"/></xsl:attribute>
         </xsl:element>
       </td>
       </tr></table>
       </xsl:if>
       <div style="padding:5px">Available 
         in the following projections:<br/> 
         <xsl:for-each select="wmts:TileMatrixSetLink/wmts:TileMatrixSet">
           <xsl:element name="a">
             <xsl:attribute name="href">
               http://spatialreference.org/ref/?search=<xsl:value-of select="."/>
             </xsl:attribute>
             <xsl:value-of select="."/>
           </xsl:element>;
         </xsl:for-each>
       </div>
       <div style="padding:5px">Styles: 
         <xsl:for-each select="wmts:Style">
           <xsl:value-of select="ows:Identifier"/>;&#160;
         </xsl:for-each>
       </div>
       <div style="padding:5px">Formats: 
         <xsl:for-each select="wmts:Format">
           <xsl:value-of select="."/>;&#160;
         </xsl:for-each>
       </div>
     </div>
   <table style="padding-left:20px"><tr><td>
     <xsl:apply-templates select="wmts:Layer"/>
   </td></tr></table>
</xsl:template>

<xsl:template match="ows:ServiceContact">
   <xsl:element name="a">
      <xsl:attribute name="href">mailto:<xsl:value-of select="ows:ContactInfo/ows:ElectronicMailAddress"/></xsl:attribute>
      <xsl:value-of select="ows:IndividualName"/> 
   </xsl:element> 
   | 
   <xsl:value-of select="ows:ContactInfo/ows:Address/ows:Street"/>&#160;
   <xsl:value-of select="ows:ContactInfo/ows:Address/ows:PostalCode"/>&#160;
   <xsl:value-of select="ows:ContactInfo/ows:Address/ows:City"/>&#160;
   <xsl:value-of select="ows:ContactInfo/ows:Address/ows:Country"/>&#160;
   | 
   <xsl:value-of select="ows:ContactInfo/ows:Phone/ows:Voice"/>
</xsl:template>

</xsl:stylesheet>
