<?xml version="1.0" encoding="UTF-8"?>
<!-- WU BEGIN 
Edit history:
- 20211015 by LSS to set static values in LDR and 008 fields
- 20211015 by LSS to make some static values lower case  
- 20211015 by LSS to substitute YYYY placeholder in 264 $c and 502 $a  
- 20210528 by LSS to add 502 and 710 fields 

Purpose:
This file is the XSLT to convert Islandora theses MODS records to Marc in order to create Alma print thesis records. It can be used in MarcEdit Tools or in any XSLT interpreter such as XML Notepad.
It is initially based upon the default MODS to Marc21 XSLT converter in MarcEdit, but has been extensively modified by Wesleyan to fit our own data.
See explanations of field mappings here:
https://docs.google.com/spreadsheets/d/1kEcpSG2uheLLJnO8OxDHJkAh5x-3pZXUvuvqgNgo0Yk/edit#gid=0
WU END -->
<!-- WU BEGIN - added xmlns:etd declaration to be able to get at the etd attributes -->
<xsl:stylesheet version="1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="mods xlink"
	xmlns:marc="http://www.loc.gov/MARC21/slim" 
	xmlns:etd="http://www.ndltd.org/standards/metadata/etdms/1.0" 
	xmlns:date="http://exslt.org/dates-and-times">
<!-- WU END --> 
  <!-- MODS v3 to MARC21Slim transformation  	ntra 2/20/04 -->

  <xsl:include href="http://www.loc.gov/marcxml/xslt/MARC21slimUtils.xsl"/>

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="mods:modsCollection">
    <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
      <xsl:apply-templates/>
    </marc:collection>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--<xsl:template match="mods:targetAudience/mods:listValue" mode="ctrl008">-->
  <xsl:template match="mods:targetAudience[@authority='marctarget']" mode="ctrl008">
    <xsl:choose>
      <xsl:when test=".='adolescent'">d</xsl:when>
      <xsl:when test=".='adult'">e</xsl:when>
      <xsl:when test=".='general'">g</xsl:when>
      <xsl:when test=".='juvenile'">j</xsl:when>
      <xsl:when test=".='preschool'">a</xsl:when>
      <xsl:when test=".='specialized'">f</xsl:when>
      <xsl:otherwise>
        <xsl:text>|</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods:typeOfResource" mode="leader">
    <xsl:choose>
      <xsl:when test="text()='text' and @manuscript='yes'">t</xsl:when>
      <xsl:when test="text()='text'">a</xsl:when>
      <xsl:when test="text()='cartographic' and @manuscript='yes'">f</xsl:when>
      <xsl:when test="text()='cartographic'">e</xsl:when>
      <xsl:when test="text()='notated music' and @manuscript='yes'">d</xsl:when>
      <xsl:when test="text()='notated music'">c</xsl:when>
      <!-- v3 musical/non -->
      <xsl:when test="text()='sound recording-nonmusical'">i</xsl:when>
      <xsl:when test="text()='sound recording'">j</xsl:when>
      <xsl:when test="text()='sound recording-musical'">j</xsl:when>
      <xsl:when test="text()='still image'">k</xsl:when>
      <xsl:when test="text()='moving image'">g</xsl:when>
      <xsl:when test="text()='three dimensional object'">r</xsl:when>
      <xsl:when test="text()='software, multimedia'">m</xsl:when>
      <xsl:when test="text()='mixed material'">p</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods:typeOfResource" mode="ctrl008">
    <xsl:choose>
      <xsl:when test="text()='text' and @manuscript='yes'">BK</xsl:when>
      <xsl:when test="text()='text'">
        <xsl:choose>
          <xsl:when test="../mods:originInfo/mods:issuance='monographic'">BK</xsl:when>
          <xsl:when test="../mods:originInfo/mods:issuance='continuing'">SE</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="text()='cartographic' and @manuscript='yes'">MP</xsl:when>
      <xsl:when test="text()='cartographic'">MP</xsl:when>
      <xsl:when test="text()='notated music' and @manuscript='yes'">MU</xsl:when>
      <xsl:when test="text()='notated music'">MU</xsl:when>
      <xsl:when test="text()='sound recording'">MU</xsl:when>
      <!-- v3 musical/non -->
      <xsl:when test="text()='sound recording-nonmusical'">MU</xsl:when>
      <xsl:when test="text()='sound recording-musical'">MU</xsl:when>
      <xsl:when test="text()='still image'">VM</xsl:when>
      <xsl:when test="text()='moving image'">VM</xsl:when>
      <xsl:when test="text()='three dimensional object'">VM</xsl:when>
      <xsl:when test="text()='software, multimedia'">CF</xsl:when>
      <xsl:when test="text()='mixed material'">MM</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="controlField008-24-27">
    <xsl:variable name="chars">
      <xsl:for-each select="mods:genre[@authority='marc']">
        <xsl:choose>
          <xsl:when test=".='abstract of summary'">a</xsl:when>
          <xsl:when test=".='bibliography'">b</xsl:when>
          <xsl:when test=".='catalog'">c</xsl:when>
          <xsl:when test=".='dictionary'">d</xsl:when>
          <xsl:when test=".='directory'">r</xsl:when>
          <xsl:when test=".='discography'">k</xsl:when>
          <xsl:when test=".='encyclopedia'">e</xsl:when>
          <xsl:when test=".='filmography'">q</xsl:when>
          <xsl:when test=".='handbook'">f</xsl:when>
          <xsl:when test=".='index'">i</xsl:when>
          <xsl:when test=".='law report or digest'">w</xsl:when>
          <xsl:when test=".='legal article'">g</xsl:when>
          <xsl:when test=".='legal case and case notes'">v</xsl:when>
          <xsl:when test=".='legislation'">l</xsl:when>
          <xsl:when test=".='patent'">j</xsl:when>
          <xsl:when test=".='programmed text'">p</xsl:when>
          <xsl:when test=".='review'">o</xsl:when>
          <xsl:when test=".='statistics'">s</xsl:when>
          <xsl:when test=".='survey of literature'">n</xsl:when>
          <xsl:when test=".='technical report'">t</xsl:when>
          <xsl:when test=".='theses'">m</xsl:when>
          <xsl:when test=".='treaty'">z</xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="makeSize">
      <xsl:with-param name="string" select="$chars"/>
      <xsl:with-param name="length" select="4"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="controlField008-30-31">
    <xsl:variable name="chars">
      <xsl:for-each select="mods:genre[@authority='marc']">
        <xsl:choose>
          <xsl:when test=".='biography'">b</xsl:when>
          <xsl:when test=".='conference publication'">c</xsl:when>
          <xsl:when test=".='drama'">d</xsl:when>
          <xsl:when test=".='essay'">e</xsl:when>
          <xsl:when test=".='fiction'">f</xsl:when>
          <xsl:when test=".='folktale'">o</xsl:when>
          <xsl:when test=".='history'">h</xsl:when>
          <xsl:when test=".='humor, satire'">k</xsl:when>
          <xsl:when test=".='instruction'">i</xsl:when>
          <xsl:when test=".='interview'">t</xsl:when>
          <xsl:when test=".='language instruction'">j</xsl:when>
          <xsl:when test=".='memoir'">m</xsl:when>
          <xsl:when test=".='rehersal'">r</xsl:when>
          <xsl:when test=".='reporting'">g</xsl:when>
          <xsl:when test=".='sound'">s</xsl:when>
          <xsl:when test=".='speech'">l</xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="makeSize">
      <xsl:with-param name="string" select="$chars"/>
      <xsl:with-param name="length" select="2"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="makeSize">
    <xsl:param name="string"/>
    <xsl:param name="length"/>
    <xsl:variable name="nstring" select="normalize-space($string)"/>
    <xsl:variable name="nstringlength" select="string-length($nstring)"/>
    <xsl:choose>
      <xsl:when test="$nstringlength&gt;$length">
        <xsl:value-of select="substring($nstring,1,$length)"/>
      </xsl:when>
      <xsl:when test="$nstringlength&lt;$length">
        <xsl:value-of select="$nstring"/>
        <xsl:call-template name="buildSpaces">
          <xsl:with-param name="spaces" select="$length - $nstringlength"/>
          <xsl:with-param name="char">|</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nstring"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods:mods">
    <marc:record>
      <marc:leader>
        <!-- 00-04 -->
        <xsl:text>     </xsl:text>
        <!-- 05 -->
        <xsl:text>n</xsl:text>
        <!-- 06 -->
<!-- <xsl:apply-templates mode="leader" select="mods:typeOfResource[1]"/> -->		
<!-- WU BEGIN - 06 static "t" for theses -->
		<xsl:text>t</xsl:text>		
        <!-- 07 -->
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:issuance='monographic'">m</xsl:when>
          <xsl:when test="mods:originInfo/mods:issuance='continuing'">s</xsl:when>
          <xsl:when test="mods:typeOfResource/@collection='yes'">c</xsl:when>
          <xsl:otherwise>m</xsl:otherwise>
        </xsl:choose>
        <!-- 08 -->
        <xsl:text> </xsl:text>
        <!-- 09 -->
        <xsl:text> </xsl:text>
        <!-- 10 -->
        <xsl:text>2</xsl:text>
        <!-- 11 -->
        <xsl:text>2</xsl:text>
        <!-- 12-16 -->
        <xsl:text>     </xsl:text>
        <!-- 17 -->
<!--        <xsl:text>u</xsl:text> -->
<!-- WU BEGIN - 17 static "m" for theses -->
		<xsl:text>m</xsl:text>
        <!-- 18 -->
<!--        <xsl:text>u</xsl:text> -->
<!-- WU BEGIN - 18 static "a" for theses -->
		<xsl:text>a</xsl:text>
        <!-- 19 -->
        <xsl:text> </xsl:text>
        <!-- 20-23 -->
        <xsl:text>4500</xsl:text>
      </marc:leader>
      <xsl:call-template name="controlRecordInfo"/>
      <xsl:if test="mods:genre[@authority='marc']='atlas'">
        <marc:controlfield tag="007">ad||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="mods:genre[@authority='marc']='model'">
        <marc:controlfield tag="007">aq||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="mods:genre[@authority='marc']='remote sensing image'">
        <marc:controlfield tag="007">ar||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="mods:genre[@authority='marc']='map'">
        <marc:controlfield tag="007">aj||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="mods:genre[@authority='marc']='globe'">
        <marc:controlfield tag="007">d|||||</marc:controlfield>
      </xsl:if>
      <marc:controlfield tag="008">
        <xsl:variable name="typeOf008">
          <xsl:apply-templates mode="ctrl008" select="mods:typeOfResource"/>
        </xsl:variable>
        <!-- 00-05 -->
<!-- 
        <xsl:choose>
          <xsl:when test="mods:recordInfo/mods:recordContentSource[@authority='marcorg']">
            <xsl:value-of select="mods:recordInfo/mods:recordCreationDate[@encoding='marc']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>      </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 00-05 static "YYMMDD" for theses -->
		<xsl:text>YYMMDD</xsl:text>

        <!-- 06 -->
<!--
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:issuance='monographic' and count(mods:originInfo/mods:dateIssued)=1">s</xsl:when>
          <xsl:when test="mods:originInfo/mods:dateIssued[@qualifier='questionable']">q</xsl:when>
          <xsl:when test="mods:originInfo/mods:issuance='monographic' and mods:originInfo/mods:dateIssued[@point='start'] and mods:originInfo/mods:dateIssued[@point='end']">m</xsl:when>
          <xsl:when test="mods:originInfo/mods:issuance='continuing' and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']='9999'">c</xsl:when>
          <xsl:when test="mods:originInfo/mods:issuance='continuing' and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']='uuuu'">u</xsl:when>
          <xsl:when test="mods:originInfo/mods:issuance='continuing' and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']">d</xsl:when>
          <xsl:when test="not(mods:originInfo/mods:issuance) and mods:originInfo/mods:dateIssued">s</xsl:when>
          <xsl:when test="mods:originInfo/mods:copyrightDate">s</xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 06 static "s" for theses -->
		<xsl:text>s</xsl:text>

        <!-- 07-14          -->
        <!-- 07-10 -->
<!--
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:dateIssued[@point='start' and @encoding='marc']">
            <xsl:value-of select="mods:originInfo/mods:dateIssued[@point='start' and @encoding='marc']"/>
          </xsl:when>
          <xsl:when test="mods:originInfo/mods:dateIssued[@encoding='marc']">
            <xsl:value-of select="mods:originInfo/mods:dateIssued[@encoding='marc']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>    </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 07-10 static "YYYY" for theses -->
		<xsl:text>YYYY</xsl:text>
        <!-- 11-14 -->
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']">
            <xsl:value-of select="mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>    </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- 15-17 -->
<!--		
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry']">
            <xsl:value-of select="mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry']"/>
            <xsl:if test="string-length(mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry'])=2">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>   </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 15-17 static "xx " for theses -->
		<xsl:text>xx </xsl:text>

        <!-- 18-20 -->
        <xsl:text>|||</xsl:text>
        <!-- 21 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='SE'">
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='database'">d</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='loose-leaf'">l</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='newspaper'">n</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='periodical'">p</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='series'">m</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='web site'">w</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 22 -->
        <!-- 1/04 fix -->
        <xsl:choose>
          <xsl:when test="mods:targetAudience[@authority='marctarget']">
            <xsl:apply-templates mode="ctrl008" select="mods:targetAudience[@authority='marctarget']"/>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 23 -->
<!--        <xsl:choose>
          <xsl:when test="$typeOf008='BK' or $typeOf008='MU' or $typeOf008='SE' or $typeOf008='MM'">
            <xsl:choose>
              <xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='braille'">f</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='electronic'">s</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='microfiche'">b</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='microfilm'">a</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form[@authority='marcform']='print'">
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose> -->
<!-- WU BEGIN - 23 static "\" for theses -->		
		<xsl:text>\</xsl:text>
        <!-- 24-27 -->
<!--
        <xsl:choose>
          <xsl:when test="$typeOf008='BK'">
            <xsl:call-template name="controlField008-24-27"/>
          </xsl:when>
          <xsl:when test="$typeOf008='MP'">
            <xsl:text>|</xsl:text>
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='atlas'">e</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='globe'">d</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
            <xsl:text>||</xsl:text>
          </xsl:when>
          <xsl:when test="$typeOf008='CF'">
            <xsl:text>||</xsl:text>
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='database'">e</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='font'">f</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='game'">g</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='numerical data'">a</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='sound'">h</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
            <xsl:text>|</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>||||</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 24-27 static "mb||" for theses -->		
		<xsl:text>mb||</xsl:text>
        <!-- 28 -->
        <xsl:text>|</xsl:text>
        <!-- 29 -->
<!--
        <xsl:choose>
          <xsl:when test="$typeOf008='BK' or $typeOf008='SE'">
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='conference publication'">1</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$typeOf008='MP' or $typeOf008='VM'">
            <xsl:choose>
              <xsl:when test="mods:physicalDescription/mods:form='braille'">f</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form='electronic'">m</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form='microfiche'">b</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form='microfilm'">a</xsl:when>
              <xsl:when test="mods:physicalDescription/mods:form='print'">
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
-->
        <!-- 30-31 -->
<!--
        <xsl:choose>
          <xsl:when test="$typeOf008='MU'">
            <xsl:call-template name="controlField008-30-31"/>
          </xsl:when>
          <xsl:when test="$typeOf008='BK'">
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='festschrift'">1</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
            <xsl:text>|</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>||</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 29-31 static "000" for theses -->		
		<xsl:text>000</xsl:text>
        <!-- 32 -->
        <xsl:text>|</xsl:text>
        <!-- 33 -->
<!--
        <xsl:choose>
          <xsl:when test="$typeOf008='VM'">
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='art originial'">a</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='art reproduction'">c</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='chart'">n</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='diorama'">d</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='filmstrip'">f</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='flash card'">o</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='graphic'">k</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='kit'">b</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='technical drawing'">l</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='slide'">s</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='realia'">r</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='picture'">i</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='motion picture'">m</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='model'">q</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='microscope slide'">p</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='toy'">w</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='transparency'">t</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='videorecording'">v</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$typeOf008='BK'">
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='comic strip'">c</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='fiction'">1</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='essay'">e</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='drama'">d</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='humor, satire'">h</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='letter'">i</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='novel'">f</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='short story'">j</xsl:when>
              <xsl:when test="mods:genre[@authority='marc']='speech'">s</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
-->
<!-- WU BEGIN - 33 static "0" for theses -->		
		<xsl:text>0</xsl:text>
        <!-- 34 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='BK'">
            <xsl:choose>
              <xsl:when test="mods:genre[@authority='marc']='biography'">d</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 35-37 -->
        <xsl:choose>
          <!-- v3 language -->
          <xsl:when test="mods:language/mods:languageTerm[@authority='iso639-2b']">
            <xsl:value-of select="mods:language/mods:languageTerm[@authority='iso639-2b']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>|||</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- 38-39 -->
<!--        <xsl:text>||</xsl:text> -->
<!-- WU BEGIN - 38-39 static "|d" for theses -->		
		<xsl:text>|d</xsl:text>
      </marc:controlfield>
      <!-- 1/04 fix sort -->
      <xsl:call-template name="source"/>
      <xsl:apply-templates/>
<!-- WU BEGIN - not using 050
      <xsl:if test="mods:classification[@authority='lcc']">
        <xsl:call-template name="lcClassification"/>
      </xsl:if>
WU END -->	  
    </marc:record>
  </xsl:template>


<!-- WU BEGIN - removed 041, 521 -->
<!-- WU BEGIN - added:
- ; $c 29cm after 300 $a
- 336, 337, 338, 502
-->
  <xsl:template match="mods:physicalDescription">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--<xsl:template match="mods:physicalDescription/mods:extent">-->
  <xsl:template match="mods:extent">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">300</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
		  <xsl:text> ;&#160;</xsl:text>
        </marc:subfield>
        <marc:subfield code='c'>
		  <xsl:text>29 cm</xsl:text>
        </marc:subfield>
      </xsl:with-param>	  
    </xsl:call-template>
	 <xsl:call-template name="datafield">
      <xsl:with-param name="tag">336</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
			<xsl:text>text</xsl:text>
        </marc:subfield>
        <marc:subfield code='b'>
			<xsl:text>txt</xsl:text>
        </marc:subfield>
        <marc:subfield code='2'>
			<xsl:text>rdacontent</xsl:text>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
	 <xsl:call-template name="datafield">
      <xsl:with-param name="tag">337</xsl:with-param>	  
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
			<xsl:text>unmediated</xsl:text>
        </marc:subfield>
        <marc:subfield code='b'>
			<xsl:text>n</xsl:text>
        </marc:subfield>
        <marc:subfield code='2'>
			<xsl:text>rdamedia</xsl:text>
        </marc:subfield>
      </xsl:with-param>			
    </xsl:call-template>
	 <xsl:call-template name="datafield">
      <xsl:with-param name="tag">338</xsl:with-param>	  
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
			<xsl:text>volume</xsl:text>
        </marc:subfield>
        <marc:subfield code='b'>
			<xsl:text>nc</xsl:text>
        </marc:subfield>
        <marc:subfield code='2'>
			<xsl:text>rdacarrier</xsl:text>
        </marc:subfield> 
      </xsl:with-param>	  
    </xsl:call-template>
  </xsl:template>
<!-- WU END - add added fields 300 $c , 336, 337, 338 -->
<!-- WU BEGIN - removed 511, 518, 500  WU END -->

<!-- WU BEGIN - changed match field @type value for 506 and 540 WU END -->
  <xsl:template match="mods:accessCondition">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">
        <xsl:choose>
          <xsl:when test="@type='restriction on access'">506</xsl:when>
          <xsl:when test="@type='use and reproduction'">540</xsl:when>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="source">
    <xsl:for-each select="mods:recordInfo/mods:recordContentSource[@authority='marcorg']">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">040</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code="a">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

 <!-- WU BEGIN - removed 044, 046, 250, 310, 260, 210, 242, 246, 240, 130, 730 WU END -->
 
<!-- BEGIN WU Author 100 -->
  <xsl:template match="mods:name[@type='personal'][mods:role/mods:roleTerm[@type='text']='author']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">100</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="mods:namePart[@type='family']"/>
		  <xsl:text>, </xsl:text>
		  <xsl:value-of select="mods:namePart[@type='given']"/>
        </marc:subfield>
		<marc:subfield code="e">
			<xsl:text>author.</xsl:text>
		</marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
<!-- END WU Author --> 

 
<!-- WU BEGIN -
- 245 - change ind2 to 0
- eliminate additional titles (246, 520)
WU END -->
  <!--<xsl:template match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)]">-->
<xsl:template match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)][1]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">245</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
        <xsl:call-template name="authordisplayForm"/>
      </xsl:with-param>
    </xsl:call-template>
	<!-- WU BEGIN - 264 static value -->
      <xsl:call-template name="datafield">
      <xsl:with-param name="tag">264</xsl:with-param>
	  <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="c">
		  <xsl:text>YYYY</xsl:text>
        </marc:subfield>	  
      </xsl:with-param>
    </xsl:call-template>
<!-- WU END -->
  </xsl:template>
 <!-- WU BEGIN - removed 246, 505, 752, 255 WU END -->

<!-- WU BEGIN - title - eliminate partnumber, partname portions. add colon if subtitle exists. add / after end -->
  <xsl:template name="titleInfo">
    <xsl:for-each select="mods:title">
		<xsl:choose>
			<xsl:when test="../mods:subTitle">
					<marc:subfield code="a">
						<xsl:value-of select="../mods:title"/>
						<xsl:text> :&#160;</xsl:text>
						<xsl:text> </xsl:text>
					</marc:subfield>
					<marc:subfield code="b">
						<xsl:value-of select="../mods:subTitle"/>
						<xsl:text> /&#160;</xsl:text>
					</marc:subfield>
			</xsl:when>
			<xsl:otherwise>
					<marc:subfield code="a">
						<xsl:value-of select="."/>
						<xsl:text> /&#160;</xsl:text>
					</marc:subfield>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:for-each>
  </xsl:template>
<!-- WU END - title eliminate partnumber, partname portions. use displayForm of name. add / after end. -->
  <xsl:template name="authordisplayForm">  
      <xsl:for-each select="../mods:name[@type='personal'][mods:role/mods:roleTerm[@type='text']='author'][mods:displayForm]">
		<marc:subfield code='c'>
			<xsl:value-of select="mods:displayForm"/>
			<xsl:text>.</xsl:text>
		</marc:subfield>
</xsl:for-each>
  </xsl:template>

<!-- BEGIN WU 264 replaced with static content 2021.10.14
  <xsl:template match="mods:originInfo">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="mods:dateCreated">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">264</xsl:with-param>
	  <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="c">
			<xsl:value-of select="."/>
        </marc:subfield>	  
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
END WU add new fields 264 -->

<!-- BEGIN WU Thesis advisor -->
  <xsl:template match="mods:name[@type='personal'][mods:role/mods:roleTerm[@type='text']='Thesis advisor']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">700</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="mods:displayForm"/>
		  <xsl:text>,&#160;</xsl:text>		  
        </marc:subfield>
        <marc:subfield code="e">
			<xsl:text>thesis advisor.</xsl:text>
        </marc:subfield>		
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  
<!-- END WU Thesis advisor -->  

  <xsl:template name="authorityInd">
    <xsl:choose>
      <xsl:when test="@authority='lcsh'">0</xsl:when>
      <xsl:when test="@authority='lcshac'">1</xsl:when>
      <xsl:when test="@authority='mesh'">2</xsl:when>
      <xsl:when test="@authority='csh'">3</xsl:when>
      <xsl:when test="@authority='nal'">5</xsl:when>
      <xsl:when test="@authority='rvm'">6</xsl:when>
      <xsl:when test="@authority">7</xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
      <!-- v3 blank ind2 fix-->
    </xsl:choose>
  </xsl:template>

<!-- BEGIN WU add new field 520 -->
  <xsl:template match="mods:abstract">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">520</xsl:with-param>
	  <xsl:with-param name="ind2">3</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>	
<!-- END WU add new fields 520 -->

<!-- BEGIN WU 502 and 710 - also needed to add etd namespace in stylesheet declaration at top -->
<!-- there may be multiple etd:disciplines.  using the first one for the 502 -->
<xsl:template match="mods:extension">
	 <xsl:call-template name="datafield">
      <xsl:with-param name="tag">502</xsl:with-param>	  
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
			<xsl:text>Thesis (B.A., Honors, </xsl:text>
			<xsl:value-of select="etd:degree/etd:discipline[1]" />
			<xsl:text>)--Wesleyan University, YYYY.</xsl:text>
        </marc:subfield>
      </xsl:with-param>	  
    </xsl:call-template>
<!-- each etd:discipline gets its own 710 -->
   <xsl:for-each select="etd:degree/etd:discipline">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">710</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="subfields"> 
		<marc:subfield code="a">
			<xsl:text>Wesleyan University.</xsl:text>
		</marc:subfield>
        <marc:subfield code="b">
          <xsl:value-of select="."/>
			<xsl:text>,&#160;</xsl:text>		  
		</marc:subfield>			
		<marc:subfield code="e">
			<xsl:text>degree grantor.</xsl:text>
		</marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
	</xsl:for-each>
  </xsl:template>
<!-- END WU 710 --> 

<!-- BEGIN WU modified 856 -->
  <xsl:template match="mods:location[mods:url]">
    <xsl:for-each select="mods:url">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">856</xsl:with-param>
		<xsl:with-param name="ind1">4</xsl:with-param>
		<xsl:with-param name="ind2">1</xsl:with-param>		
        <xsl:with-param name="subfields">
          <marc:subfield code="u">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>  
  <xsl:template match="mods:location">
    <xsl:apply-templates/>
  </xsl:template>
<!-- END WU modified 856 -->

<!-- BEGIN WU - 690 subject/topic -->
  <xsl:template match="mods:subject[local-name(*[1])='topic']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">690</xsl:with-param>
      <xsl:with-param name="ind2">4</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="*[1]"/>
        </marc:subfield>
        <xsl:apply-templates select="*[position()>1]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
<!-- END WU 690 -->

<!-- Required for control fields -->
  <xsl:template name="controlRecordInfo">
    <!--<xsl:template match="mods:recordInfo">-->
    <xsl:for-each select="mods:recordInfo/mods:recordIdentifier">
      <marc:controlfield tag="001">
        <xsl:value-of select="."/>
      </marc:controlfield>
      <xsl:for-each select="@source">
        <marc:controlfield tag="003">
          <xsl:value-of select="."/>
        </marc:controlfield>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="mods:recordInfo/mods:recordChangeDate[@encoding='iso8601']">
      <marc:controlfield tag="005">
        <xsl:value-of select="."/>
      </marc:controlfield>
    </xsl:for-each>
  </xsl:template>  
 
</xsl:stylesheet>
