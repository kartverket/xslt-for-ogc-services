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

<xsl:template match="WMT_MS_Capabilities">
   <html>
   <head>
     <title><xsl:value-of select="Service/Title"/> [GetCapabilities]</title>
     <link rel="stylesheet" type="text/css" href="/xslt/kartverket.css"/>
     <link rel="stylesheet" type="text/css" href="/xslt/galleria.skv.css"/>
   </head>
   <body>

   <div class="page-header">
    <div class="navbar">
     <div class="content-wrapper">
       <h1 class="site-logo">
         <span>Kartverket</span></h1>

         <ul class="nav">
            <li><a href="http://kartverket.no/Om-Kartverket/"><span>
                Om Kartverket</span></a> </li>
         </ul>
     </div>
    </div>
   </div>

   <div class="page-main-content startpage">
   <div class="content-wrapper" id="page-content">

   <xsl:for-each select="Service">
       <div>
         <table>
           <div class="header lined">
             <h2 class="h">Service: <xsl:value-of select="Title"/><b style="left: 113px;"></b></h2>
           </div>

           <tr><td colspan="2"><b><xsl:value-of select="Abstract"/></b></td></tr>
           <tr><td>Type:</td><td><xsl:value-of select="Name"/>&#160;<xsl:value-of select="//WMT_MS_Capabilities/@version"/>
             <xsl:if test="MaxWidth">
               (max. display size: <xsl:value-of select="MaxWidth"/>x<xsl:value-of select="MaxHeight"/>)
             </xsl:if>
           </td></tr>
           <tr><td>Base URL:</td><td>
             <xsl:element name="a">
               <xsl:attribute name="href"><xsl:value-of select="substring-before(OnlineResource/@*[local-name()='href'],'?')"/></xsl:attribute>
               <xsl:value-of select="substring-before(OnlineResource/@*[local-name()='href'],'?')"/>
             </xsl:element>
           </td></tr>
           <tr><td colspan="2"><hr/></td></tr>
           <tr><td>Contact:</td><td><xsl:apply-templates select="ContactInformation"/></td></tr>
           <tr><td>Access:</td><td><xsl:value-of select="AccessConstraints"/></td></tr>
           <tr><td>Fees:</td><td><xsl:value-of select="Fees"/></td></tr>
           <tr><td colspan="2"><hr/></td></tr>
         </table>
       </div>
     </xsl:for-each>
     <xsl:for-each select="Capability">
       <h2>Supported methods</h2>
       <table>
          <xsl:for-each select="Request/*">
            <tr><td>
              <b><xsl:value-of select="name(.)"/></b> 
            </td><td>
              <b> returns </b>
            </td><td>
              <xsl:for-each select="Format">
                <xsl:value-of select="."/>, 
              </xsl:for-each>
            </td><td>
              <b> methods </b> 
            </td><td>
              <xsl:for-each select="DCPType">
                <xsl:for-each select="*">
                  <xsl:value-of select="name(.)"/>&#160; 
                  <xsl:for-each select="*">
                    <xsl:element name="a">
                      <xsl:attribute name="href"><xsl:value-of select="OnlineResource/@*[local-name()='href']"/></xsl:attribute>
                      <xsl:value-of select="name(.)"/>
                    </xsl:element>;
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
         </td></tr>
            </xsl:for-each>
       </table>
       <div><h2>Layers</h2></div>
       <xsl:apply-templates select="Layer"/>
     </xsl:for-each>
   </div>
   </div>
   </body>
   </html>
</xsl:template>

<xsl:template name="selectScale">
   <xsl:if test="MaxScaleDenominator"> <!-- choose broken here? -->
     <xsl:if test="MinScaleDenominator"> 
       <xsl:call-template name="zoomniva">
         <xsl:with-param name="scale"><xsl:value-of select="(MinScaleDenominator + MaxScaleDenominator) div 2"/></xsl:with-param>
       </xsl:call-template>
     </xsl:if>
     <xsl:if test="not(MinScaleDenominator)"> 
       <xsl:call-template name="zoomniva">
         <xsl:with-param name="scale"><xsl:value-of select="MaxScaleDenominator * 2 div 3"/></xsl:with-param>
       </xsl:call-template>
     </xsl:if>
   </xsl:if>
   <xsl:if test="MinScaleDenominator"> <!-- choose broken here? -->
     <xsl:if test="not(MaxScaleDenominator)"> 
       <xsl:call-template name="zoomniva">
         <xsl:with-param name="scale"><xsl:value-of select="MinScaleDenominator * 3 div 2"/></xsl:with-param>
       </xsl:call-template>
     </xsl:if>
   </xsl:if>
   <xsl:if test="not(MaxScaleDenominator) and not(MinScaleDenominator)">5</xsl:if>
</xsl:template>

<xsl:template match="Layer">
  <xsl:variable name="url">
    <xsl:value-of select="substring-before(//Service/OnlineResource/@*[local-name()='href'], '?')"/>
  </xsl:variable>
  <xsl:variable name="client">
    http://labs.kartverket.no/norgeskart/wmsc.html?id=<xsl:value-of select="Name"/>&amp;url=<xsl:value-of select="$url"/>&amp;name=<xsl:value-of select="Title"/>&amp;layers=<xsl:value-of select="Name"/>#<xsl:call-template name="selectScale"/>/189721/6833548
  </xsl:variable>

  <xsl:choose>
     <xsl:when test="not(@queryable='0') and Name"> 
       <div style="border:1px solid #c1c1c1;">
       <div style="background-color:#ededed; padding:5px"><b>
         <xsl:value-of select="Title"/></b> - 
         <xsl:element name="a">
           <xsl:attribute name="href"><xsl:value-of select="$client"/></xsl:attribute>
           <xsl:value-of select="'Map client'"/>
         </xsl:element>
         <xsl:if test="Style/LegendURL">
           - <xsl:element name="a">
             <xsl:attribute name="href"><xsl:value-of select="Style/LegendURL/OnlineResource/@*[local-name()='href']"/></xsl:attribute>
             <xsl:value-of select="'Legend'"/>
           </xsl:element>
         </xsl:if>
         <xsl:if test="not(Style/LegendURL)">
           - Legend not available
         </xsl:if>
       </div>
       <div style="padding:5px"><xsl:value-of select="Abstract"/></div>
       <xsl:if test="../../Capability and Name">
       <table><tr><td>
         <xsl:element name="iframe">
           <xsl:attribute name="width">640</xsl:attribute>
           <xsl:attribute name="height">480</xsl:attribute>
           <xsl:attribute name="scrolling">no</xsl:attribute>
           <xsl:attribute name="frameborder">0</xsl:attribute>
           <xsl:attribute name="src"><xsl:value-of select="$client"/></xsl:attribute>
         </xsl:element>
       </td>
       <xsl:if test="Style/LegendURL">
         <td><div style="width:250; height:480; overflow:auto;">
           <xsl:element name="a">
             <xsl:attribute name="href"><xsl:value-of select="Style/LegendURL/OnlineResource/@*[local-name()='href']"/></xsl:attribute>
             <xsl:element name="img">
               <xsl:attribute name="src"><xsl:value-of select="Style/LegendURL/OnlineResource/@*[local-name()='href']"/></xsl:attribute>
             </xsl:element> 
           </xsl:element> 
         </div></td>
       </xsl:if>
       </tr></table>
       </xsl:if>
       <xsl:apply-templates select="Attribution"/> 
       <xsl:if test="SRS">
       <div style="padding:5px">Available 
         <xsl:if test="MinScaleDenominator">from scale 1:<xsl:value-of select="MinScaleDenominator"/> 
           (zoom level <xsl:call-template name="zoomniva">
               <xsl:with-param name="scale"><xsl:value-of select="MinScaleDenominator"/></xsl:with-param>
             </xsl:call-template>)
          </xsl:if>
         <xsl:if test="MaxScaleDenominator">until scale 1:<xsl:value-of select="MaxScaleDenominator"/>
           (zoom level <xsl:call-template name="zoomniva">
               <xsl:with-param name="scale"><xsl:value-of select="MaxScaleDenominator"/></xsl:with-param>
             </xsl:call-template>)
          </xsl:if>
         in the following projections:<br/> 
         <xsl:for-each select="SRS">
           <xsl:element name="a">
             <xsl:attribute name="href">http://epsg.io/<xsl:value-of select="substring(.,6)"/></xsl:attribute>
             <xsl:value-of select="."/>
           </xsl:element>;
         </xsl:for-each>
       </div>
       </xsl:if>
       </div>
     </xsl:when>
     <xsl:otherwise>
       <div style="color:#888"><b><xsl:value-of select="Title"/></b> - Not queryable directly</div>
       <div><xsl:value-of select="Abstract"/></div>
     </xsl:otherwise>
   </xsl:choose>
   <table style="margin-left:20px"><tr><td>
     <xsl:apply-templates select="Layer"/>
   </td></tr></table>
</xsl:template>

<xsl:template match="ContactInformation">
   <xsl:element name="a">
      <xsl:attribute name="href">mailto:<xsl:value-of select="ContactElectronicMailAddress"/></xsl:attribute>
      <xsl:value-of select="ContactPersonPrimary/ContactPerson"/>, 
      <xsl:value-of select="ContactPersonPrimary/ContactOrganization"/>
   </xsl:element> 
   <xsl:if test="ContactPosition and ContactPosition != 'null'">| 
     <xsl:value-of select="ContactPosition"/>
   </xsl:if>
   | 
   <xsl:value-of select="ContactAddress/Street"/>&#160;
   <xsl:value-of select="ContactAddress/PostCode"/>&#160;
   <xsl:value-of select="ContactAddress/City"/>&#160;
   <xsl:value-of select="ContactAddress/Country"/>&#160;
   | 
   <xsl:value-of select="ContactVoiceTelephone"/>
</xsl:template>

<xsl:template match="Attribution">
  <div style="padding:5px">
    Attribution: 
    <xsl:if test="LogoURL">
      &#160;
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="LogoURL/OnlineResource/@*[local-name()='href']"/>
        </xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="height">25</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:value-of select="LogoURL/OnlineResource/@*[local-name()='href']"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
      &#160;
    </xsl:if>
    <xsl:value-of select="Title"/>
  </div>
</xsl:template>

</xsl:stylesheet>
