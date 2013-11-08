<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:wms="http://www.opengis.net/wms"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- an XSLT stylesheet to display GetCapabilities calls -->
<!-- by Kartverket/Thomas Hirsch 2012 - Public Domain    -->

<xsl:output method="html" />

<xsl:template name="zoomniva">
<!-- since importing the ln function is too heavy, we just use precalculated levels -->
  <xsl:param name="scale"/>
  <xsl:if test="$scale &gt; 61409764">0</xsl:if>
  <xsl:if test="$scale &lt;=61409764 and $scale &gt; 30704882">1</xsl:if>
  <xsl:if test="$scale &lt;=30704882 and $scale &gt; 15352441">2</xsl:if>
  <xsl:if test="$scale &lt;=15352441 and $scale &gt; 7676220" >3</xsl:if>
  <xsl:if test="$scale &lt;= 7676220 and $scale &gt; 3838110" >4</xsl:if>
  <xsl:if test="$scale &lt;= 3838110 and $scale &gt; 1910550" >5</xsl:if>
  <xsl:if test="$scale &lt;= 1910550 and $scale &gt; 959572.6">6</xsl:if>
  <xsl:if test="$scale &lt;=959572.6 and $scale &gt; 479763.8">7</xsl:if>
  <xsl:if test="$scale &lt;=479763.8 and $scale &gt; 239881.9">8</xsl:if>
  <xsl:if test="$scale &lt;=239881.9 and $scale &gt; 119940.9">9</xsl:if>
  <xsl:if test="$scale &lt;=119940.9 and $scale &gt; 59970.47">10</xsl:if>
  <xsl:if test="$scale &lt;=59970.47 and $scale &gt; 29985.23">11</xsl:if>
  <xsl:if test="$scale &lt;=29985.23 and $scale &gt; 14992.62">12</xsl:if>
  <xsl:if test="$scale &lt;=14992.62 and $scale &gt; 7496.309">13</xsl:if>
  <xsl:if test="$scale &lt;=7496.309 and $scale &gt; 3748.155">14</xsl:if>
  <xsl:if test="$scale &lt;=3748.155 and $scale &gt; 1874.077">15</xsl:if>
  <xsl:if test="$scale &lt;=1874.077 and $scale &gt; 937.0386">16</xsl:if>
  <xsl:if test="$scale &lt;=937.0386">17</xsl:if>
</xsl:template>

<xsl:template match="wms:WMS_Capabilities">
   <html>
   <head>
     <title><xsl:value-of select="wms:Service/wms:Title"/> [GetCapabilities]</title>
   </head>
   <body>
     <xsl:for-each select="wms:Service">
       <div>
         <table>
           <tr><td><b>Service:</b></td><td><b><xsl:value-of select="wms:Title"/></b></td></tr>
           <tr><td>Type:</td><td><xsl:value-of select="wms:Name"/>
             <xsl:if test="wms:MaxWidth">
               (max. display size: <xsl:value-of select="wms:MaxWidth"/>x<xsl:value-of select="wms:MaxHeight"/>)
             </xsl:if>
           </td></tr>
           <tr><td>Base URL:</td><td>
             <xsl:element name="a">
               <xsl:attribute name="href"><xsl:value-of select="wms:OnlineResource/@*[local-name()='href']"/></xsl:attribute>
               <xsl:value-of select="wms:OnlineResource/@*[local-name()='href']"/>
             </xsl:element>
           </td></tr>
           <tr><td colspan="2"><xsl:value-of select="wms:Abstract"/></td></tr>
           <tr><td colspan="2"><hr/></td></tr>
           <tr><td>Contact:</td><td><xsl:apply-templates select="wms:ContactInformation"/></td></tr>
           <tr><td>Access:</td><td><xsl:value-of select="wms:AccessConstraints"/></td></tr>
           <tr><td>Fees:</td><td><xsl:value-of select="wms:Fees"/></td></tr>
           <tr><td colspan="2"><hr/></td></tr>
         </table>
       </div>
     </xsl:for-each>
     <xsl:for-each select="wms:Capability">
       <table>
         <tr><td>Supported methods:</td><td>
            <ul>
            <xsl:for-each select="wms:Request/*">
              <li><b><xsl:value-of select="name(.)"/>:</b> 
              <b> returns </b> <xsl:for-each select="wms:Format">
                 <xsl:value-of select="."/>, 
              </xsl:for-each>
              <b> methods </b> <xsl:for-each select="wms:DCPType">
                <xsl:for-each select="*">
                  <xsl:value-of select="name(.)"/>&#160; 
                  <xsl:for-each select="*">
                    <xsl:value-of select="name(.)"/>, 
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each></li>
            </xsl:for-each>
            </ul>
         </td></tr>
       </table>
       <div><h2>Layers</h2></div>
       <xsl:apply-templates select="wms:Layer"/>
     </xsl:for-each>
   </body>
   </html>
</xsl:template>

<xsl:template name="selectScale">
   <xsl:if test="wms:MaxScaleDenominator"> <!-- choose broken here? -->
     <xsl:if test="wms:MinScaleDenominator"> 
       <xsl:call-template name="zoomniva">
         <xsl:with-param name="scale"><xsl:value-of select="(wms:MinScaleDenominator + wms:MaxScaleDenominator) div 2"/></xsl:with-param>
       </xsl:call-template>
     </xsl:if>
     <xsl:if test="not(wms:MinScaleDenominator)"> 
       <xsl:call-template name="zoomniva">
         <xsl:with-param name="scale"><xsl:value-of select="wms:MaxScaleDenominator * 2 div 3"/></xsl:with-param>
       </xsl:call-template>
     </xsl:if>
   </xsl:if>
   <xsl:if test="wms:MinScaleDenominator"> <!-- choose broken here? -->
     <xsl:if test="not(wms:MaxScaleDenominator)"> 
       <xsl:call-template name="zoomniva">
         <xsl:with-param name="scale"><xsl:value-of select="wms:MinScaleDenominator * 3 div 2"/></xsl:with-param>
       </xsl:call-template>
     </xsl:if>
   </xsl:if>
   <xsl:if test="not(wms:MaxScaleDenominator) and not(wms:MinScaleDenominator)">5</xsl:if>
</xsl:template>

<xsl:template match="wms:Layer">
  <xsl:variable name="url">
    <xsl:value-of select="//wms:Service/wms:OnlineResource/@*[local-name()='href']"/>
  </xsl:variable>
  <xsl:variable name="client">
    http://labs.kartverket.no/wms.html?id=<xsl:value-of select="wms:Name"/>&amp;url=<xsl:value-of select="$url"/>&amp;name=<xsl:value-of select="wms:Title"/>&amp;layers=<xsl:value-of select="wms:Name"/>#<xsl:call-template name="selectScale"/>/189721/6833548
  </xsl:variable>

  <xsl:choose>
     <xsl:when test="not(@queryable='0')"> 
       <div style="border:1px solid green;">
       <div style="background-color:#dfd; padding:5px"><b>
         <xsl:value-of select="wms:Title"/></b> - 
         <xsl:element name="a">
           <xsl:attribute name="href"><xsl:value-of select="$client"/></xsl:attribute>
           <xsl:value-of select="'Map client'"/>
         </xsl:element>
         <xsl:if test="wms:Style/wms:LegendURL">
           - <xsl:element name="a">
             <xsl:attribute name="href"><xsl:value-of select="wms:Style/wms:LegendURL/wms:OnlineResource/@*[local-name()='href']"/></xsl:attribute>
             <xsl:value-of select="'Legend'"/>
           </xsl:element>
         </xsl:if>
         <xsl:if test="not(wms:Style/wms:LegendURL)">
           - Legend not available
         </xsl:if>
       </div>
       <div style="padding:5px"><xsl:value-of select="wms:Abstract"/></div>
       <xsl:if test="../../wms:Capability">
       <table><tr><td>
         <xsl:element name="iframe">
           <xsl:attribute name="width">640</xsl:attribute>
           <xsl:attribute name="height">480</xsl:attribute>
           <xsl:attribute name="scrolling">no</xsl:attribute>
           <xsl:attribute name="frameborder">0</xsl:attribute>
           <xsl:attribute name="src"><xsl:value-of select="$client"/></xsl:attribute>
         </xsl:element>
       </td>
       <xsl:if test="wms:Style/wms:LegendURL">
         <td><div style="width:250; height:480; overflow:auto;">
           <xsl:element name="a">
             <xsl:attribute name="href"><xsl:value-of select="wms:Style/wms:LegendURL/wms:OnlineResource/@*[local-name()='href']"/></xsl:attribute>
             <xsl:element name="img">
               <xsl:attribute name="src"><xsl:value-of select="wms:Style/wms:LegendURL/wms:OnlineResource/@*[local-name()='href']"/></xsl:attribute>
             </xsl:element> 
           </xsl:element> 
         </div></td>
       </xsl:if>
       </tr></table>
       </xsl:if>
       <xsl:apply-templates select="wms:Attribution"/> 
       <div style="padding:5px">Available 
         <xsl:if test="wms:MinScaleDenominator">from scale 1:<xsl:value-of select="wms:MinScaleDenominator"/> 
           (zoom level <xsl:call-template name="zoomniva">
               <xsl:with-param name="scale"><xsl:value-of select="wms:MinScaleDenominator"/></xsl:with-param>
             </xsl:call-template>)
          </xsl:if>
         <xsl:if test="wms:MaxScaleDenominator">until scale 1:<xsl:value-of select="wms:MaxScaleDenominator"/>
           (zoom level <xsl:call-template name="zoomniva">
               <xsl:with-param name="scale"><xsl:value-of select="wms:MaxScaleDenominator"/></xsl:with-param>
             </xsl:call-template>)
          </xsl:if>
         in the following projections:<br/> 
         <xsl:for-each select="wms:CRS">
           <xsl:element name="a">
             <xsl:attribute name="href">
               http://spatialreference.org/ref/epsg/<xsl:value-of select="substring(.,6)"/>/
             </xsl:attribute>
             <xsl:value-of select="."/>
           </xsl:element>;
         </xsl:for-each>
       </div>
       </div>
     </xsl:when>
     <xsl:otherwise>
       <div style="color:#888"><b><xsl:value-of select="wms:Title"/></b> - Not queryable directly</div>
       <div><xsl:value-of select="wms:Abstract"/></div>
     </xsl:otherwise>
   </xsl:choose>
   <table style="padding-left:20px"><tr><td>
     <xsl:apply-templates select="wms:Layer"/>
   </td></tr></table>
</xsl:template>

<xsl:template match="wms:ContactInformation">
   <xsl:element name="a">
      <xsl:attribute name="href">mailto:<xsl:value-of select="wms:ContactElectronicMailAddress"/></xsl:attribute>
      <xsl:value-of select="wms:ContactPersonPrimary/wms:ContactPerson"/>, 
      <xsl:value-of select="wms:ContactPersonPrimary/wms:ContactOrganization"/>
   </xsl:element> 
   | 
   <xsl:value-of select="wms:ContactPosition"/>
   | 
   <xsl:value-of select="wms:ContactAddress"/>
   | 
   <xsl:value-of select="wms:ContactVoiceTelephone"/>
</xsl:template>

<xsl:template match="wms:Attribution">
  <div style="padding:5px">
    Attribution: 
    <xsl:if test="wms:LogoURL">
      &#160;
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="wms:LogoURL/wms:OnlineResource/@*[local-name()='href']"/>
        </xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="height">25</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:value-of select="wms:LogoURL/wms:OnlineResource/@*[local-name()='href']"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
      &#160;
    </xsl:if>
    <xsl:value-of select="wms:Title"/>
  </div>
</xsl:template>

</xsl:stylesheet>
