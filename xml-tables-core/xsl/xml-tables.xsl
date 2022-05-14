<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*" />

    <xsl:template match="/">
        <html lang="en">
            <head>
                <title>XML Table</title>
                <!-- Meta tags -->
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <meta charset="utf-8"/>
                

                <!-- Include Bootstrap JS,Bootstrap CSS, JQuery , D3libraries -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"/>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
                <script src="https://d3js.org/d3.v7.min.js"></script>
                
            </head>
            <body>

                <!-- Setting up the navigation bar [Bootstrap template]-->
                <div id="navigation-bar" class="fixed-top">
                    <nav class="nav navbar navbar-expand-md navbar-light">
                    <!-- Visualization Link Start-->
                        <div class="container-fluid">
                            <ul class="nav navbar-nav me-auto">
                                <li id="homepage" class="nav-item me-2">
                                    <a class="nav-link active" data-bs-toggle="tab" data-bs-target="#home" role="tab" href="#">Tabular</a>
                                </li>
                                <li id="vizpage2D" class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" data-bs-target="#viz2D" role="tab" href="#">Graph View</a>
                                </li>
                            </ul>


                            <!-- Visualization Link End-->

                            <form class="d-flex my-0">
                                <input id="search-input" class="form-control ms-auto me-2" type="search" placeholder="Search"/>
                                <button id="btn-export-json" class="btn btn-custom text-nowrap me-2">Export to JSON</button>
                                <button id="btn-export-csv" class="btn btn-custom text-nowrap">Export to CSV</button>
                            </form>
                        </div>
                        
                    </nav>
                </div>


                <!-- Navigation Panes Definition Start -->
                <div class="tab-content" id="xml-tabs">
                    <!-- Visualization Pane Starts -->
                    <div class="tab-pane fade  d-flex flex-row" id="viz2D" role="tabpanel">

                    </div>
                    <!-- Visualization Pane Ends -->



                    <!-- Home Pane -->

                    <div class="tab-pane fade show active" id="home" role="tabpanel">
                        <div id="xml-table-container" class=" table-responsive container my-5 ">

                            <table id="xml-table" class="table table-sm table-hover table-borderless">
                                <thead class="row">
                                    <tr class="row">
                                        <th class="col-1">Parent UID</th>
                                        <th class="col-1">Object UID</th>
                                        <th class="col-1">Node Type</th>
                                        <th class="col-2">Node Name</th>
                                        <th class="col-3">Node Value</th>
                                        <th class="col-4">Node Path</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <xsl:call-template name="generate-row"/>

                                </tbody>
                            </table>

                        </div>
                    </div>
                    <!-- Home Pane Ends -->
                </div >
                <!-- Navigation Panes Definition Ends -->




            </body>
        </html>
    </xsl:template>




    <xsl:template name="generate-row" match="@*|node()" mode="build-table">

        <!-- Load Column variables -->
        <xsl:variable name="parent-uid">
            <xsl:value-of select ="generate-id(parent::node()) "/>
        </xsl:variable>
        <xsl:variable name="object-uid">
            <xsl:value-of select ="generate-id()"/>
        </xsl:variable>
        <xsl:variable name="get-node-type">
            <xsl:call-template name="node-type"/>
        </xsl:variable>
        <xsl:variable name="get-node-name">
            <xsl:call-template name="node-name"/>
        </xsl:variable>
        <xsl:variable name="get-node-value">
            <xsl:call-template name="node-value"/>
        </xsl:variable>
        <xsl:variable name="get-node-path">
            <xsl:call-template name="node-path"/>
        </xsl:variable>

        <!-- Populate HTML table with a single row -->

        <tr class="row">
            <xsl:attribute name="parent-uid">
                <xsl:value-of select = "$parent-uid"/>
            </xsl:attribute>
            <xsl:attribute name="object-uid">
                <xsl:value-of select = "$object-uid"/>
            </xsl:attribute>
            <xsl:attribute name="node-name">
                <xsl:value-of select = "$get-node-name"/>
            </xsl:attribute>
            <xsl:attribute name="node-type">
                <xsl:value-of select = "$get-node-type"/>
            </xsl:attribute>
            <xsl:attribute name="node-value">
                <xsl:value-of select = "$get-node-value"/>
            </xsl:attribute>


            <td class="parent-uid text-muted fw-lighter col-1 text-break">
                <xsl:value-of select ="$parent-uid"/>
            </td>
            <td class="object-uid text-muted fw-lighter col-1 text-break">
                <xsl:value-of select ="$object-uid"/>
            </td>
            <td class="node-type col-1 text-break">
                <xsl:value-of select ="$get-node-type"/>
            </td>
            <td class="node-name col-2 text-break">
                <xsl:value-of select ="$get-node-name"/>
            </td>
            <td class="node-value col-3 text-break">
                <xsl:value-of select ="$get-node-value"/>
            </td>
            <td class="node-path text-muted fw-lighter col-4 text-break">
                <xsl:value-of select ="$get-node-path"/>
            </td>
        </tr>

        <!-- Recursive call to the child nodes with same template -->
        <xsl:apply-templates select="@*|node()" mode="build-table"/>

    </xsl:template>

    <!-- Load the Node Name Column -->
    <xsl:template name="node-name">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                Root element
            </xsl:when>
            <xsl:when test="self::*">
                <xsl:value-of select ="name()"/>
            </xsl:when>
            <xsl:when test="self::text()">
                Text node
            </xsl:when>
            <xsl:when test="self::comment()">
                Comment node
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <xsl:value-of select ="name()"/>
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <xsl:value-of select ="name()"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Load the Node Type Column -->
    <xsl:template name="node-type">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                <xsl:text>Root</xsl:text>
            </xsl:when>
            <xsl:when test="self::*">
                <xsl:text>Element</xsl:text>
                <xsl:if test="substring-before(name(),':')">
                    <xsl:text>:Composite</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="self::text()">
                <xsl:text>Text</xsl:text>
            </xsl:when>
            <xsl:when test="self::comment()">
                <xsl:text>Comment</xsl:text>
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <xsl:text>Processing Instruction</xsl:text>
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <xsl:text>Attribute</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Load the Node Value Column -->
    <xsl:template name="node-value">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                <!-- Root Element -->
                Root Node
            </xsl:when>
            <xsl:when test="self::*">
                <!-- Element Node -->
                Element Node
            </xsl:when>
            <xsl:when test="self::text()">
                <!-- Text Node -->
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="self::comment()">
                <!-- Comment Node -->
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <!-- Processing Instruction Node -->
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <!-- Attribute Node -->
                <xsl:value-of select="." />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Load the Node Path Column -->
    <xsl:template name="node-path">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                <!-- Root Element -->
                #root
            </xsl:when>
            <xsl:when test="self::*">
                <!-- Element Node -->
                <xsl:call-template name="build-xpath"/>
            </xsl:when>
            <xsl:when test="self::text()">
                <!-- Text Node -->
                <xsl:call-template name="build-xpath"/>
            </xsl:when>
            <xsl:when test="self::comment()">
                <!-- Comment Node -->
                #comment
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <!-- Processing Instruction Node -->
                #processing-instruction
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <!-- Attribute Node -->
                <xsl:call-template name="build-xpath"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Build Xpath -->
    <xsl:variable name="vApos">'</xsl:variable>

    <xsl:template name="build-xpath">

        <xsl:if test="self::*">
            <xsl:apply-templates select="ancestor-or-self::*" mode="path"/>
        </xsl:if>

        <xsl:if test="self::text()">
            <xsl:apply-templates select="ancestor-or-self::*" mode="path"/>
            <xsl:value-of select="concat('=',$vApos,.,$vApos)"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>

        <xsl:if test="count(.|../@*)=count(../@*)">
            <xsl:apply-templates select="../ancestor-or-self::*" mode="path"/>
            <xsl:value-of select="concat('[@',name(), '=',$vApos,.,$vApos,']')"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="path">
        <xsl:value-of select="concat('/',name())"/>
        <xsl:variable name="vnumPrecSiblings" select="count(preceding-sibling::*[name()=name(current())])"/>
        <xsl:if test="$vnumPrecSiblings">
            <xsl:value-of select="concat('[', $vnumPrecSiblings +1, ']')"/>
        </xsl:if>
    </xsl:template>



</xsl:stylesheet>