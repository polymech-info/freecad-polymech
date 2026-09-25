<?xml version="1.0" encoding="utf-8" standalone="yes"?>

<!--
  Copyright (c) 2007-2008 by HSMWorks ApS
  All rights reserved
  http://www.hsmworks.com
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:locale="http://www.cimco-software.com/xml/2003/locale"
                exclude-result-prefixes="locale">


<!-- the title of the html document -->
<xsl:param name="html.title"
           select="'Locale for Mastercam HSM Performance Pack Release 1'"/>

<!-- the url of the html stylesheet -->
<xsl:param name="html.css" select="''"/>

<!-- enable to show legend -->
<xsl:param name="show.legend" select="true()"/>

<!-- enable to show built-in messages for localized messages -->
<xsl:param name="show.builtin" select="true()"/>

<!-- enable to show indices -->
<xsl:param name="show.indices" select="true()"/>

<!-- enable to show localized messages -->
<xsl:param name="show.localized" select="true()"/>

<!-- enable to show non-localized messages -->
<xsl:param name="show.nonlocalized" select="true()"/>

<xsl:param name="locale.document" select="''"/>


<xsl:output method="html"
            encoding="utf-8"/>


<xsl:template name="get.translated">
  <xsl:param name="message"/>
  <xsl:value-of select="$message"/>
</xsl:template>


<xsl:template name="write.localized">
  <xsl:param name="index"/>
  <xsl:param name="builtin"/>
  <xsl:param name="localized"/>

  <div class="message">
    <xsl:if test="$show.indices">
      <div class="index">
        <xsl:value-of select="$index"/>
      </div>
    </xsl:if>
    
    <div class="builtin">
      <xsl:if test="$show.builtin">
        <xsl:value-of select="$builtin"/>
      </xsl:if>
    </div>

    <xsl:choose>
      <xsl:when test="$builtin=$localized">
        <div class="identical">
          <xsl:value-of select="$localized"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="localized">
          <xsl:value-of select="$localized"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template name="write.nonlocalized">
  <xsl:param name="index"/>
  <xsl:param name="builtin"/>

  <div class="message">
    <xsl:if test="$show.indices">
      <div class="index"><xsl:value-of select="$index"/></div>
    </xsl:if>

    <div class="builtin"><xsl:value-of select="$builtin"/></div>
    
    <div class="nonlocalized">
      <xsl:value-of select="$builtin"/>
    </div>
  </div>
</xsl:template>


<xsl:template match="/">
<html>
  <head>
    <title><xsl:value-of select="$html.title"/></title>

    <style type="text/css">div.legend {border: solid 4px gray; margin-bottom: 20px; padding: 5px; background: #f0f0f0} div.legend div.row {padding: 5px} div.legend div.row div {display: inline; vertical-align: middle; margin-right: 10px} div.legend div.row div.notlocalized {border: none; line-height: 10px; padding-left: 15px; background: #f0b0b0} div.legend div.identical {border: none; line-height: 10px; padding-left: 15px; background: #b0b0f0} div.description {font-size: 10pt; font-weight: bold} div.message {border: solid 1px gray; margin-top: 10px; margin-bottom: 10px; padding: 5px; background: #f8f8f8; font-size: 11pt; font-weight: bold} div.message div.index {border: none; font-weight: bold; padding: 0px} div.message div {border: solid 1px gray; margin-top: 5px; padding: 2px; font-size: 10pt} div.builtin {background: white} div.identical {background: #b0b0f0} div.localized {background: white} div.nonlocalized {background: #f0b0b0} body {background: white; font-family: arial,helvetica,sans-serif}</style>
  </head>
  <body>
    <xsl:apply-templates select="locale:locale"/>
  </body>
</html>
</xsl:template>

<xsl:template name="write.legend">
  <div class="legend">
    <div class="row">
      <div class="notlocalized">&#xa0;</div>
      <div class="description">
        <xsl:call-template name="get.translated">
          <xsl:with-param name="message" select="'message has not been localized'"/>
        </xsl:call-template>
      </div>
    </div>
    <div class="row">
      <div class="identical">&#xa0;</div>
      <div class="description">
        <xsl:call-template name="get.translated">
          <xsl:with-param name="message" select="'localized message is identical to built-in message'"/>
        </xsl:call-template>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template match="locale:locale">
  <h1 class="title"><xsl:value-of select="$html.title"/></h1>

  <xsl:apply-templates select="locale:description"/>

  <xsl:if test="$show.legend">
    <xsl:call-template name="write.legend"/>
  </xsl:if>

  <xsl:apply-templates select="locale:message"/>
</xsl:template>

<xsl:template match="locale:description">
  <h2 class="locale"><xsl:value-of select="."/></h2>
</xsl:template>

<xsl:template match="locale:message">
  <xsl:comment><xsl:value-of select="@name"/></xsl:comment>
  <xsl:choose>
    <xsl:when test=".!=''">
      <xsl:call-template name="write.localized">
        <xsl:with-param name="index" select="position()"/>
        <xsl:with-param name="builtin" select="@name"/>
        <xsl:with-param name="localized" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$show.nonlocalized">
        <xsl:call-template name="write.nonlocalized">
          <xsl:with-param name="index" select="position()"/>
          <xsl:with-param name="builtin" select="@name"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
