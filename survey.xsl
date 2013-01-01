<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
 
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
 
  <xsl:template match="/survey">
    <html>
      <head> 
	<title>Testing XML Example</title> 
	<script type="text/javascript" src="jquery.js"></script> 
	<script type="text/javascript" src="survey.js"></script> 
	<link rel="stylesheet" href="style.css" type="text/css" />
      </head>
      <body onload="startup()">
        <h1>Survey questions</h1>
	<form>
          <xsl:apply-templates select="page">
         <!--   <xsl:sort select="family-name" /> -->
          </xsl:apply-templates>
	  <input type="submit" value="Finish" id="done" />
        </form>
      </body>
    </html>
  </xsl:template>
 
  <xsl:template match="page">
    <div class="page">
      <xsl:apply-templates select="title" />
      <ol>
	<p><xsl:value-of select="text" /></p>
	<xsl:apply-templates select="question" />
      </ol>
    </div>
  </xsl:template>

  <xsl:template match="question">
    <xsl:variable name="questionNo">
      <xsl:number level="any" />
    </xsl:variable>
    <li value="{$questionNo}">
      <div class="question">
	<xsl:apply-templates />
      </div>
    </li>
  </xsl:template>

  <xsl:template match="title">
    <h2><xsl:value-of select="current()" /></h2>
  </xsl:template>

  <xsl:template match="likert">
    <table class="likert">
      <thead>
	<xsl:apply-templates select="scale" />      
      </thead>
      <tbody>
	<xsl:apply-templates select="statement" />      
      </tbody>
    </table>
  </xsl:template>
  
  <xsl:template match="scale">
    <tr>
      <td><!-- place holder for statment text --></td>
      <xsl:for-each select="description">
	<td class="description"><xsl:value-of select="current()" /></td>
      </xsl:for-each>
    </tr>
  </xsl:template>

  <xsl:template match="statement">
    <tr>
      <td class="statement"><xsl:value-of select="current()" /></td>
      <xsl:variable name="likertId" select="generate-id()" />
      <xsl:for-each select="../scale/description">
	<td><input type="radio" name="likert-{$likertId}" value="{position()}"></input></td>
      </xsl:for-each>
    </tr>
  </xsl:template>

  <xsl:template match="freetext">
    <div>
      <label>
        <div class="freetext"><xsl:value-of select="current()" /></div><xsl:text>: </xsl:text>
        <input type="text" name="text-{generate-id()}" />
      </label>
    </div>
  </xsl:template>

  <xsl:template match="list">
    <select>
      <xsl:for-each select="option"> 
	<option value="{position()}"><xsl:value-of select="current()" /></option>
      </xsl:for-each>
    </select>
  </xsl:template>
</xsl:stylesheet>