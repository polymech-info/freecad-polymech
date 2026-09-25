<?xml version="1.0" encoding="utf-8" standalone="yes"?>

<!--
  Copyright (c) 2007-2012 by HSMWorks ApS
  All rights reserved
  http://www.hsmworks.com

  $Revision: 1665 $
  $Date: 2004-12-22 09:51:06 +0100 (Wed, 22 Dec 2004) $
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nc-stats="http://www.hsmworks/xml/2004/nc-stats"
                xmlns:locale="http://www.hsmworks.com/xml/2008/locale"
                exclude-result-prefixes="nc-stats locale">

<xsl:param name="debug" select="false()"/>

<!-- the url of the html stylesheet -->
<xsl:param name="html.css" select="'ncstats.css'"/>
<xsl:param name="unit" select="'unit'"/>

<xsl:param name="locale-url" select="''"/>
<xsl:param name="locale-name" select="'English'"/>
<xsl:param name="locale-country" select="'en'"/>

<xsl:param name="pi" select="3.1415926535897932384626433832795"/>

<xsl:decimal-format name="nan" NaN="0"/>

<xsl:param name="format-spacial" select="'0.##'"/>
<xsl:param name="format-angle" select="'0.0'"/>
<xsl:param name="format-percentage" select="'0.0'"/>



<xsl:output method="html"
            encoding="utf-8"
            doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>

<xsl:variable name="localized-messages"
              select="document($locale-url)/locale:locale/locale:message[@name]"/>

<xsl:template name="get-localized">
  <xsl:param name="message" select="''"/>

  <xsl:variable name="localized-message">
    <xsl:value-of select="$localized-messages[@name=$message]"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$localized-message != ''">
      <xsl:value-of select="$localized-message"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$debug">
        <xsl:message>message '<xsl:value-of select="$message"/>' has not been localized</xsl:message>
      </xsl:if>
      <xsl:value-of select="$message"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="percentage">
  <xsl:param name="value" select="0"/>
  <xsl:text> (</xsl:text>
  <xsl:value-of select="format-number($value * 100, $format-percentage)"/>
  <xsl:text>%)</xsl:text>
</xsl:template>

<xsl:template match="/">

  <link rel="stylesheet" type="text/css">
    <xsl:attribute name="href">
      <xsl:value-of select="$html.css"/>
    </xsl:attribute>
  </link>

<html>
  <head>
    <title>
      <xsl:call-template name="get-localized">
        <xsl:with-param name="message" select="'Toolpath Analysis'"/>
      </xsl:call-template>
    </title>
  </head>
  <body>
    <xsl:apply-templates select="nc-stats:nc-stats"/>
  </body>
</html>
</xsl:template>

<xsl:template match="nc-stats:nc-stats">
  <h1 class="title">
    <xsl:call-template name="get-localized">
      <xsl:with-param name="message" select="'Toolpath Analysis'"/>
    </xsl:call-template>
  </h1>

  <xsl:apply-templates select="nc-stats:description"/>

  <h3 class="section">
    <xsl:call-template name="get-localized">
      <xsl:with-param name="message" select="'Feed'"/>
    </xsl:call-template>
  </h3>

  <table cellspacing="0px">
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Minimum feedrate'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:feed/@minimum-feedrate, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/><xsl:text>/min</xsl:text></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Maximum feedrate'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:feed/@maximum-feedrate, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/><xsl:text>/min</xsl:text></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Average feedrate'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:feed/@average-feedrate, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/><xsl:text>/min</xsl:text></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Machining time'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:variable name="time" select="nc-stats:feed/@feed-time"/>
        <xsl:value-of select="floor($time div 60 div 60)"/>
        <xsl:text>h </xsl:text>
        <xsl:value-of select="floor($time div 60) mod 60"/>
        <xsl:text>m </xsl:text>
        <xsl:value-of select="floor($time) mod 60"/>
        <xsl:text>s</xsl:text>
      </td>
    </tr>
  </table>

  <div class="bounding-box">
    <h3 class="section">
      <xsl:call-template name="get-localized">
        <xsl:with-param name="message" select="'Bounding box'"/>
      </xsl:call-template>
    </h3>

    <table cellspacing="0px">
      <tr>
        <td class="description">
          <xsl:call-template name="get-localized">
            <xsl:with-param name="message" select="'Axis'"/>
          </xsl:call-template>
        </td>
        <td class="value">
          <xsl:call-template name="get-localized">
            <xsl:with-param name="message" select="'Minimum'"/>
          </xsl:call-template>
        </td>
        <td class="value">
          <xsl:call-template name="get-localized">
            <xsl:with-param name="message" select="'Maximum'"/>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td class="description">
          <xsl:call-template name="get-localized">
            <xsl:with-param name="message" select="'X-axis'"/>
          </xsl:call-template>
        </td>
        <td class="value"><xsl:value-of select="format-number(nc-stats:bounding-box/@x-minimum, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
        <td class="value"><xsl:value-of select="format-number(nc-stats:bounding-box/@x-maximum, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
      </tr>
      <tr>
        <td class="description">
          <xsl:call-template name="get-localized">
            <xsl:with-param name="message" select="'Y-axis'"/>
          </xsl:call-template>
        </td>
        <td class="value"><xsl:value-of select="format-number(nc-stats:bounding-box/@y-minimum, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
        <td class="value"><xsl:value-of select="format-number(nc-stats:bounding-box/@y-maximum, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
      </tr>
      <tr>
        <td class="description">
          <xsl:call-template name="get-localized">
            <xsl:with-param name="message" select="'Z-axis'"/>
          </xsl:call-template>
        </td>
        <td class="value"><xsl:value-of select="format-number(nc-stats:bounding-box/@z-minimum, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
        <td class="value"><xsl:value-of select="format-number(nc-stats:bounding-box/@z-maximum, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
      </tr>
    </table>
  </div>

  <h3 class="section">
    <xsl:call-template name="get-localized">
      <xsl:with-param name="message" select="'Counts'"/>
    </xsl:call-template>
  </h3>

  <xsl:variable name="entities" select="nc-stats:counts/@entities"/>

  <table cellspacing="0px">
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of entities'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="nc-stats:counts/@entities"/></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of tool changes'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:counts/@tool-changes"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:counts/@tool-changes div $entities"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of rapid moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:counts/@rapid-moves"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:counts/@rapid-moves div $entities"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of lead moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:counts/@lead-moves"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:counts/@lead-moves div $entities"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of cutting moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:counts/@cutting-moves"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:counts/@cutting-moves div $entities"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of linear moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:counts/@linear-moves"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:counts/@linear-moves div $entities"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of circular moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:counts/@circular-moves"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:counts/@circular-moves div $entities"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of rapid fragments'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="nc-stats:counts/@rapid-fragments"/></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of lead fragments'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="nc-stats:counts/@lead-fragments"/></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of cutting fragments'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="nc-stats:counts/@cutting-fragments"/></td>
    </tr>
  </table>

  <h3 class="section">
    <xsl:call-template name="get-localized">
      <xsl:with-param name="message" select="'Distances'"/>
    </xsl:call-template>
  </h3>

  <xsl:variable name="total-distance" select="nc-stats:distances/@total-distance"/>

  <table cellspacing="0px">
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Rapid distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="format-number(nc-stats:distances/@rapid-distance, $format-spacial, 'nan')"/>
        <xsl:value-of select="$unit"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:distances/@rapid-distance div $total-distance"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Lead distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="format-number(nc-stats:distances/@lead-distance, $format-spacial, 'nan')"/>
        <xsl:value-of select="$unit"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:distances/@lead-distance div $total-distance"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Cutting distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="format-number(nc-stats:distances/@cutting-distance, $format-spacial, 'nan')"/>
        <xsl:value-of select="$unit"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:distances/@cutting-distance div $total-distance"/>
        </xsl:call-template>
      </td>
    </tr>

    <tr>
      <xsl:variable name="distance">
        <xsl:choose>
          <xsl:when test="nc-stats:counts/@rapid-fragments != 0">
            <xsl:value-of select="format-number(nc-stats:distances/@rapid-distance div nc-stats:counts/@rapid-fragments, $format-spacial, 'nan')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Average rapid fragment distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="$distance"/>
        <xsl:value-of select="$unit"/>
      </td>
    </tr>

    <tr>
      <xsl:variable name="distance">
        <xsl:choose>
          <xsl:when test="nc-stats:counts/@lead-fragments != 0">
            <xsl:value-of select="format-number(nc-stats:distances/@lead-distance div nc-stats:counts/@lead-fragments, $format-spacial, 'nan')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Average lead fragment distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="$distance"/>
        <xsl:value-of select="$unit"/>
      </td>
    </tr>

    <tr>
      <xsl:variable name="distance">
        <xsl:choose>
          <xsl:when test="nc-stats:counts/@cutting-fragments != 0">
            <xsl:value-of select="format-number(nc-stats:distances/@cutting-distance div nc-stats:counts/@cutting-fragments, $format-spacial, 'nan')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Average cutting fragment distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="$distance"/>
        <xsl:value-of select="$unit"/>
      </td>
    </tr>

    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Linear distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="format-number(nc-stats:distances/@linear-distance, $format-spacial, 'nan')"/>
        <xsl:value-of select="$unit"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:distances/@linear-distance div $total-distance"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Circular distance'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="format-number(nc-stats:distances/@circular-distance, $format-spacial, 'nan')"/>
        <xsl:value-of select="$unit"/>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:distances/@circular-distance div $total-distance"/>
        </xsl:call-template>
      </td>
    </tr>

    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Total distance'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:distances/@total-distance, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
    </tr>
  </table>

  <h3 class="section">
    <xsl:call-template name="get-localized">
      <xsl:with-param name="message" select="'General'"/>
    </xsl:call-template>
  </h3>

  <table cellspacing="0px">
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Parameter'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Minimum'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Maximum'"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Slope'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:slope/@minimum * 180 div $pi, $format-angle, 'nan')"/>&#xb0;</td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:slope/@maximum * 180 div $pi, $format-angle, 'nan')"/>&#xb0;</td>
    </tr>
  </table>

  <h3 class="section">
    <xsl:call-template name="get-localized">
      <xsl:with-param name="message" select="'Circular moves'"/>
    </xsl:call-template>
  </h3>

<xsl:choose>
<xsl:when test="nc-stats:circular-moves">
  <xsl:variable name="total" select="nc-stats:circular-moves/@ccw-moves + nc-stats:circular-moves/@cw-moves"/>

  <table cellspacing="0px">
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of XY-plane moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:circular-moves/@xy-moves"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:circular-moves/@xy-moves div $total"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of XZ-plane moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:circular-moves/@xz-moves"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:circular-moves/@xz-moves div $total"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Number of YZ-plane moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:circular-moves/@yz-moves"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:circular-moves/@yz-moves div $total"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Counterclockwise moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:circular-moves/@ccw-moves"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:circular-moves/@ccw-moves div $total"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Clockwise moves'"/>
        </xsl:call-template>
      </td>
      <td class="value">
        <xsl:value-of select="nc-stats:circular-moves/@cw-moves"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="percentage">
          <xsl:with-param name="value" select="nc-stats:circular-moves/@cw-moves div $total"/>
        </xsl:call-template>
      </td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Minimum sweep'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:circular-moves/@minimum-sweep * 180 div $pi, $format-angle, 'nan')"/>&#xb0;</td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Maximum sweep'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:circular-moves/@maximum-sweep * 180 div $pi, $format-angle, 'nan')"/>&#xb0;</td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Minimum chord length'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:circular-moves/@minimum-chord, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Maximum chord length'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:circular-moves/@maximum-chord, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Minimum radius'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:circular-moves/@minimum-radius, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
    </tr>
    <tr>
      <td class="description">
        <xsl:call-template name="get-localized">
          <xsl:with-param name="message" select="'Maximum radius'"/>
        </xsl:call-template>
      </td>
      <td class="value"><xsl:value-of select="format-number(nc-stats:circular-moves/@maximum-radius, $format-spacial, 'nan')"/><xsl:value-of select="$unit"/></td>
    </tr>
  </table>
</xsl:when>
  <xsl:otherwise>
    <p>
      <xsl:call-template name="get-localized">
        <xsl:with-param name="message" select="'No circular moves.'"/>
      </xsl:call-template>
    </p>
  </xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template match="nc-stats:description">
  <h2 class="description"><xsl:value-of select="."/></h2>
</xsl:template>

</xsl:stylesheet>
