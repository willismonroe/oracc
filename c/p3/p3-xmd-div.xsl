<?xml version='1.0' encoding="utf-8"?>

<xsl:stylesheet version="1.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:md="http://oracc.org/ns/xmd/1.0"
  xmlns:xpd="http://oracc.org/ns/xpd/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="md xpd">

<xsl:include href="xpd.xsl"/>

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="project" select="''"/>

<xsl:variable name="config-xml-file" 
	      select="concat('/usr/local/oracc/xml/',$project,'/','config.xml')"/>
<xsl:variable name="views-xml-file" 
	      select="concat('/usr/local/oracc/xml/',$project,'/','views.xml')"/>

<xsl:template match="/">
  <xsl:apply-templates mode="xmd"/>
</xsl:template>

<xsl:template mode="xmd" match="/md:xmd">
  <div class="xmdoutline border-top border-bottom">
    <xsl:call-template name="names"/>
    <xsl:call-template name="numbers"/>
    <xsl:call-template name="views"/>
    <xsl:call-template name="details"/>
    <xsl:call-template name="biblio"/>
  </div>
</xsl:template>

<xsl:template name="views-images">
  <xsl:variable name="drawing" select="/*/md:cat/md:images/md:img[@type='l'][@scale='full']"/>
  <xsl:variable name="photo" select="/*/md:cat/md:images/md:img[@type='p'][@scale='full']"/>
  <xsl:variable name="detail" select="/*/md:cat/md:images/md:img[@type='d'][@scale='full']"/>
  <!--
  <xsl:variable name="detail-uri" select="concat('http://cdli.ucla.edu/dl/',
					  $detail/@src)"/>
  <xsl:variable name="drawing-uri" select="concat('http://cdli.ucla.edu/dl/',
					   $drawing/@src)"/>
  <xsl:variable name="photo-uri" select="concat('http://cdli.ucla.edu/dl/',
					 $photo/@src)"/>
  -->
  <xsl:variable name="image-uri" select="concat('http://oracc.museum.upenn.edu/cdli/', /*/@xml:id, '/image')"/>
  <xsl:if test="$photo">
    <li><a href="{$image-uri}" target="_blank">photo</a></li>
  </xsl:if>
  <xsl:if test="$drawing">
    <li><a href="{$image-uri}" target="_blank">line art</a></li>
  </xsl:if>
  <xsl:if test="$detail">
    <li><a href="{$image-uri}" target="_blank">details</a></li>
  </xsl:if>
</xsl:template>

<xsl:template name="views">
  <h3 class="h3">Views</h3>
  <ul>
    <xsl:for-each select="/*/md:cat/md:images">
      <xsl:choose>
	<xsl:when test="@public">
	  <xsl:call-template name="views-images"/>
	</xsl:when>
	<xsl:when test="../md:public_image='yes'">
	  <xsl:call-template name="views-images"/>
	</xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:call-template name="arg-views-nowrap"/>
  </ul>
</xsl:template>

<xsl:template name="arg-views">
  <ul>
    <xsl:call-template name="arg-views-nowrap"/>
  </ul>
</xsl:template>

<xsl:template name="arg-views-nowrap">
  <xsl:variable name="text" select="/*/@xml:id"/>

  <xsl:variable name="views-buy-book">
    <xsl:call-template name="xpd-option">
      <xsl:with-param name="config-xml" select="$config-xml-file"/>
      <xsl:with-param name="option" select="'views-buy-book'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="views-cuneify">
    <xsl:call-template name="xpd-option">
      <xsl:with-param name="config-xml" select="$config-xml-file"/>
      <xsl:with-param name="option" select="'views-cuneify'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="views-proofing">
    <xsl:call-template name="xpd-option">
      <xsl:with-param name="config-xml" select="$config-xml-file"/>
      <xsl:with-param name="option" select="'views-proofing'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="views-TEI">
    <xsl:call-template name="xpd-option">
      <xsl:with-param name="config-xml" select="$config-xml-file"/>
      <xsl:with-param name="option" select="'views-TEI'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$views-cuneify='true'">
    <li><a href="javascript:cuneifyPopup('{$project}','{$text}')">Cuneified</a></li>
  </xsl:if>
  <xsl:if test="$views-proofing='true'">
    <li><a href="javascript:viewsProofing('{$project}','{$text}')">Proofing</a></li>
  </xsl:if>
  <xsl:if test="$views-TEI='true'">
    <li><a target="_blank" href="/{$project}/tei/{$text}.xml">TEI</a></li>
  </xsl:if>
  <xsl:if test="string-length($views-buy-book) > 0">
    <li><a href="javascript:viewsBuyBook('{$views-buy-book}')">Buy the Book</a></li>
  </xsl:if>

<!--
  <xsl:for-each select="document($views-xml-file)/views/view">
  <li><a href="/cgi-bin/customview.plx?project={$project}&amp;text={$text}&amp;input={input}&amp;script={script}">
  <xsl:value-of select="name"/></a></li>
  </xsl:for-each>
 -->
</xsl:template>

<xsl:template name="names">
  <h3 class="h3">Names</h3>
  <ul>
    <xsl:for-each select="/*/md:cat">
      <li>
	<xsl:value-of select="md:designation"/>
      </li>
    </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="numbers">
  <h3 class="h3">Numbers</h3>
  <ul>
    <xsl:for-each select="/*/md:cat">
      <li>
	<xsl:choose>
	  <xsl:when test="starts-with(md:id_text,'P')">
	    <a href="http://cdli.ucla.edu/{md:id_text/text()}" target="_blank">
	      <xsl:value-of select="md:id_text"/>
	    </a>
	  </xsl:when>
	  <xsl:when test="md:id_composite">
	    <xsl:value-of select="md:id_composite"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="md:id_text"/>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
      <xsl:if test="string-length(md:museum_no)>0">
	<li><xsl:value-of select="md:museum_no"/></li>
      </xsl:if>
      <xsl:if test="string-length(md:accession_no)>0">
	<li><xsl:value-of select="md:accession_no"/></li>
      </xsl:if>
      <xsl:if test="string-length(md:excavation_no)>0">
	<li><xsl:value-of select="md:excavation_no"/></li>
      </xsl:if>
      <xsl:if test="string-length(md:primary_publication)>0">
	<li><xsl:value-of select="md:primary_publication"/></li>
      </xsl:if>
    </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="details">
  <h3 class="h3">Details</h3>
  <ul>
    <xsl:for-each select="/*/md:cat">
      <xsl:if test="string-length(md:object_type)>0 
		    and not(md:object_type = 'tablet')">
	<li><xsl:value-of select="md:object_type"/></li>
      </xsl:if>
      <xsl:if test="string-length(md:period)>0">
	<li><xsl:value-of select="md:period"/>
	<xsl:if test="string-length(md:date_of_origin)>0">
	  <xsl:text> (</xsl:text><xsl:value-of select="md:date_of_origin"/><xsl:text>)</xsl:text>
	</xsl:if>
	</li>
      </xsl:if>
      <xsl:if test="string-length(md:provenience)>0">
	<li>
	  <xsl:value-of select="md:provenience"/>
	  <xsl:if test="md:provenience = 'unclear'">
	    <xsl:text> provenience</xsl:text>
	  </xsl:if>
	</li>
      </xsl:if>
      <xsl:if test="string-length(md:genre)>0">
	<li><xsl:value-of select="md:genre"/></li>
      </xsl:if>
      <xsl:if test="string-length(md:subgenre)>0">
	<li><xsl:value-of select="md:subgenre"/></li>
      </xsl:if>
      <xsl:if test="string-length(md:subgenre_remarks)>0">
	<li><xsl:value-of select="md:subgenre_remarks"/></li>
      </xsl:if>
    </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="biblio">
  <xsl:choose>
    <xsl:when test="/*/md:cat/md:bibliography__shortref
		    and string-length(/*/md:cat/md:bibliography__shortref) > 0">
      <h3 class="h3">Bibliography</h3>
      <ul>
	<xsl:choose>
	  <xsl:when test="/*/md:cat/md:bibliography__shortref/md:subfield">
	    <xsl:for-each select="/*/md:cat/md:bibliography__shortref/md:subfield">
	      <xsl:variable name="nth" select="1+count(preceding-sibling::*)"/>
	      <li>
		<!--FIXME: add a href=R000000 here-->
		<xsl:value-of select="."/>
		<xsl:variable name="rpages"
			      select="/*/md:cat/md:pr_joins__pages/md:subfield[$nth]/text()
				      |/*/md:cat/md:qr_joins__pages/md:subfield[$nth]/text()"/>
		<xsl:if test="string-length($rpages)">
		  <xsl:value-of select="concat(', ', $rpages)"/>
		</xsl:if>
	      </li>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <li>
	      <xsl:value-of select="/*/md:cat/md:bibliography__shortref/text()"/>
	      <xsl:variable name="rpages"
			    select="/*/md:cat/md:pr_joins__pages/text()
				    |/*/md:cat/md:qr_joins__pages/text()"/>
	      <xsl:if test="string-length($rpages)">
		<xsl:value-of select="concat(', ', $rpages)"/>
	      </xsl:if>
	    </li>
	  </xsl:otherwise>
	</xsl:choose>
      </ul>
    </xsl:when>
    <xsl:when test="string-length(/*/md:cat/md:publication_history)>0">
      <h3 class="h3">Bibliography</h3>
      <p><xsl:value-of select="/*/md:cat/md:publication_history"/></p>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
