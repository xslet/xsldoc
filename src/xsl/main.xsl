<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:strip-space elements="*"/>

 <xsl:param name="_xsl_url">
  <xsl:call-template name="ut:get_xsl_url"/>
 </xsl:param>

 <xsl:param name="_xsl_dir">
  <xsl:call-template name="ut:get_dir_from_url">
   <xsl:with-param name="url" select="$_xsl_url"/>
  </xsl:call-template>
 </xsl:param>

 <!--**
  The top level element of a XML stylesheet.
 -->
 <xsl:template match="/xsl:stylesheet">
  <html>
   <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title></title>
    <script src="{concat($_xsl_dir, '/xsldoc.js')}"></script>
    <link rel="stylesheet" href="{concat($_xsl_dir, '/xsldoc.css')}"/>
   </head>
   <body>
    <header>
     <xsl:call-template name="print_system_props"/>
    </header>
    <main>
     <xsl:call-template name="print_page_title"/>
     <xsl:call-template name="print_page_comment"/>
     <xsl:call-template name="print_namespaces"/>
     <xsl:call-template name="print_importings"/>
     <xsl:call-template name="print_includings"/>
     <xsl:call-template name="print_parameters"/>
     <xsl:call-template name="print_elements"/>
     <xsl:call-template name="print_functions"/>
    </main>
    <footer>
     <xsl:call-template name="print_system_props"/>
    </footer>
   </body>
  </html>
 </xsl:template>

 <!--**
  Prints system properties with XSLT system-property() function.
 -->
 <xsl:template name="print_system_props">
  <div class="system-props">
   <span class="system-props-title">System Properties:</span>
   <span class="system-prop-list">
    <span class="system-prop-item">
     <span class="system-prop-name">xsl:vendor</span>
     <span class="system-prop-value">
      <xsl:value-of select="system-property('xsl:vendor')"/>
     </span>
    </span>
    <span class="system-prop-item">
     <span class="system-prop-name">xsl:version</span>
     <span class="system-prop-value">
      <xsl:value-of select="system-property('xsl:version')"/>
     </span>
    </span>
    <span class="system-prop-item">
     <span class="system-prop-name">xsl:vendor-url</span>
     <span class="system-prop-value">
      <xsl:value-of select="system-property('xsl:vendor-url')"/>
     </span>
    </span>
   </span>
  </div>
 </xsl:template>

 <!--**
  Prints the XSL file name as the page title.
 -->
 <xsl:template name="print_page_title">
  <h1></h1>
  <script>xsldoc.printPageTitle()</script>
 </xsl:template>

 <!--**
  Prints the preceding comment of `xsl:stylesheet` element as the page comment.
 -->
 <xsl:template name="print_page_comment">
  <div class="comment page-desc">
   <xsl:call-template name="get_design_comment"/>
  </div>
 </xsl:template>

 <!--**
  Prints namespaces.
  Firefox does not always print them because Firefox does not support XPath's namespace axis (namespace::*).
 -->
 <xsl:template name="print_namespaces">
  <xsl:if test="boolean(namespace::*)">
   <section class="namespaces">
    <h2>Namespaces:</h2>
    <div class="section-body namespace-list">
     <xsl:for-each select="namespace::*">
      <div class="namespace-item">
       <span class="namespace-prefix">
        <xsl:text>xmlns:</xsl:text>
        <xsl:value-of select="name()"/>
       </span>
       <span class="namespace-uri">
        <xsl:value-of select="."/>
       </span>
      </div>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

 <!--**
  Prints import files with their design comments.
 -->
 <xsl:template name="print_importings">
  <xsl:if test="boolean(xsl:import)">
   <section class="importings">
    <h2>Importings:</h2>
    <div class="section-body importing-list">
     <xsl:for-each select="xsl:import">
      <div class="importing-item">
       <div class="importing-file">
        <a href="{concat($_xsl_dir,'/',@href)}">
         <xsl:value-of select="@href"/>
        </a>
       </div>
       <div class="comment importing-desc">
        <xsl:variable name="_desc">
         <xsl:call-template name="get_design_comment"/>
        </xsl:variable>
        <xsl:choose>
         <xsl:when test="string-length($_desc) != 0">
          <xsl:value-of select="$_desc"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:for-each select="document(@href, /)/xsl:stylesheet">
           <xsl:call-template name="get_design_comment"/>
          </xsl:for-each>
         </xsl:otherwise>
        </xsl:choose>
       </div>
      </div>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

 <!--**
  Prints include files with their design comments.
 -->
 <xsl:template name="print_includings">
  <xsl:if test="boolean(//xsl:include)">
   <section class="including-section">
    <h2>Includings:</h2>
    <div class="section-body including-list">
     <xsl:for-each select="//xsl:include">
      <div class="including-item">
       <span class="including-file">
        <a href="{concat($_xsl_dir,'/',@href)}">
         <xsl:value-of select="@href"/>
        </a>
       </span>
       <span class="comment including-desc">
        <xsl:variable name="_desc">
         <xsl:call-template name="get_design_comment"/>
        </xsl:variable>
        <xsl:choose>
         <xsl:when test="string-length($_desc) != 0">
          <xsl:value-of select="$_desc"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:for-each select="document(@href, /)/xsl:stylesheet">
           <xsl:call-template name="get_design_comment">
            <xsl:with-param name="only_one_line" select="$ut:true"/>
           </xsl:call-template>
          </xsl:for-each>
         </xsl:otherwise>
        </xsl:choose>
       </span>
      </div>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

 <!--**
  Prints parameters with their design comments.
 -->
 <xsl:template name="print_parameters">
  <xsl:if test="boolean(xsl:param[not(starts-with(@name, '_')) and not(contains(@name, ':_'))])">
   <section class="parameters">
    <h2>Parameters:</h2>
    <div class="section-body parameter-list">
     <xsl:for-each select="xsl:param">
      <xsl:choose>
       <xsl:when test="starts-with(@name, '_')"/>
       <xsl:when test="starts-with(substring-after(@name, ':'), '_')"/>
       <xsl:otherwise>
        <div class="parameter-item">
         <div class="parameter-name">
          <xsl:value-of select="@name"/>
         </div>
         <div class="comment parameter-desc">
          <xsl:call-template name="get_design_comment"/>
         </div>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

 <!--**
  Prints matched templates as elements with their design comments.
 -->
 <xsl:template name="print_elements">
  <xsl:if test="boolean(xsl:template/@match)">
   <section class="elements">
    <h2>Elements:</h2>
    <div class="section-body element-list">
     <xsl:for-each select="xsl:template[boolean(@match)]">
      <xsl:choose>
       <xsl:when test="starts-with(@match, '_')"/>
       <xsl:when test="starts-with(substring-after(@match, ':'), '_')"/>
       <xsl:otherwise>
        <div class="element-item">
         <div class="element-match">
          <xsl:value-of select="@match"/>
         </div>
         <div class="comment element-desc">
          <xsl:call-template name="get_design_comment"/>
         </div>
         <xsl:if test="boolean(xsl:param)">
          <div class="params element-param-list">
           <xsl:for-each select="xsl:param">
            <div class="element-param-item">
             <div class="element-param-name">
              <xsl:value-of select="@name"/>
             </div>
             <div class="comment element-param-desc">
              <xsl:call-template name="get_design_comment"/>
             </div>
            </div>
           </xsl:for-each>
          </div>
         </xsl:if>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

 <!--**
  Prints named templates as functions with their design comments.
 -->
 <xsl:template name="print_functions">
  <xsl:if test="boolean(xsl:template/@name[not(starts-with(., '_')) and not(contains(., ':_'))])">
   <section class="functions">
    <h2>Functions:</h2>
    <div class="section-body function-list">
     <xsl:for-each select="xsl:template[boolean(@name)]">
      <xsl:choose>
       <xsl:when test="starts-with(@name, '_')"/>
       <xsl:when test="starts-with(substring-after(@name, ':'), '_')"/>
       <xsl:otherwise>
        <div class="function-item">
         <div class="function-name">
          <xsl:value-of select="@name"/>
         </div>
         <div class="comment function-desc">
          <xsl:call-template name="get_design_comment"/>
         </div>
         <xsl:if test="boolean(xsl:param)">
          <div class="params function-param-list">
           <xsl:for-each select="xsl:param">
            <div class="function-param-item">
             <div class="function-param-name">
              <xsl:value-of select="@name"/>
             </div>
             <div class="comment function-param-desc">
              <xsl:call-template name="get_design_comment"/>
             </div>
            </div>
           </xsl:for-each>
          </div>
         </xsl:if>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
