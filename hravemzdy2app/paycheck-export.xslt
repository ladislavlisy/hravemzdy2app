<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exslt="http://exslt.org/common">

  <xsl:output method="html" indent="yes" encoding="utf-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Employee payslip</title>
      </head>

      <body>
        <xsl:apply-templates select="/payslips/payslip"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="payslip">
    <div>
      <xsl:call-template name="HEADER">
        <xsl:with-param name="data_persons_name" select="employee/common_name"/>
        <xsl:with-param name="data_persons_numb" select="employee/personnel_number"/>
        <xsl:with-param name="data_departs_name" select="employee/department"/>
        <xsl:with-param name="data_company_name" select="employer/common_name"/>
        <xsl:with-param name="data_periods_desc" select="results/period"/>
      </xsl:call-template>
      <xsl:call-template name="DETAILS_INCOME">
      </xsl:call-template>
      <xsl:call-template name="SUMMARY_INCOME">
      </xsl:call-template>
      <xsl:call-template name="DETAILS_DEDUCT">
      </xsl:call-template>
      <xsl:call-template name="SUMMARY_DEDUCT">
      </xsl:call-template>
      <xsl:call-template name="SUMMARY_PAYMENT">
      </xsl:call-template>
      <xsl:call-template name="FOOTER">
      </xsl:call-template>
      <xsl:call-template name="SIGNATURE">
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template name="HEADER">
    <xsl:param name="data_persons_name"/>
    <xsl:param name="data_persons_numb"/>
    <xsl:param name="data_departs_name"/>
    <xsl:param name="data_company_name"/>
    <xsl:param name="data_periods_desc"/>
    <div>
	    <table>
	      <tr>
          <td>Personnel number</td>
 	        <td>Person name</td>
          <td>Period</td>
        </tr>
		    <tr>
		      <td>
            <xsl:value-of select="$data_persons_numb"/>
 		      </td>
		      <td>
           <xsl:value-of select="$data_persons_name"/>
		      </td>
		      <td>
		        <xsl:value-of select="$data_periods_desc"/>
		      </td>
		    </tr>
        <tr>
          <td>Department</td>
          <td>Company</td>
          <td></td>
        </tr>
        <tr>
          <td>
            <xsl:value-of select="$data_departs_name"/>
          </td>
          <td>
            <xsl:value-of select="$data_company_name"/>
          </td>
          <td>Payslip</td>
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template name="FOOTER">
  </xsl:template>
  
  <xsl:template name="DETAILS_INCOME">
    <!-- inside variable for inner xml -->
    <xsl:variable name="income_source">
      <xsl:variable name="schedule_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_SCHEDULE'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="payments_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_PAYMENTS'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <income_item>
        <label_text>Income</label_text>
        <xsl:if test ="$schedule_count=1">
           <schedule_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_SCHEDULE']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each> 
          </schedule_item>
        </xsl:if>
        <xsl:if test ="$payments_count=1">
          <payments_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_PAYMENTS']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each>
          </payments_item>
        </xsl:if>
      </income_item>
    </xsl:variable>
    <!-- table -->
    <div>
      <xsl:variable name="blok_count">
        <xsl:choose>
          <xsl:when test="count(exslt:node-set($income_source)/income_item/*/item_detail)>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$blok_count=1">
        <table>
          <xsl:for-each select="exslt:node-set($income_source)/income_item/*/item_detail">
            <xsl:if test="(position( ) mod 2) = 1">
              <tr class="pay_tr_odd">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="(position( ) mod 2) = 0">
              <tr class="pay_tr_even">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template name="SUMMARY_INCOME">
    <!-- inside variable for inner xml -->
    <xsl:variable name="income_summary">
      <xsl:variable name="ins_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_INS_INCOME'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tax_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_TAX_INCOME'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <income_item>
        <label_text>Income</label_text>
        <xsl:if test ="$ins_count=1">
           <ins_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_INS_INCOME']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each> 
          </ins_item>
        </xsl:if>
        <xsl:if test ="$tax_count=1">
          <tax_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_TAX_INCOME']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each>
          </tax_item>
        </xsl:if>
      </income_item>
    </xsl:variable>
    <!-- table -->
    <div>
      <xsl:variable name="blok_count">
        <xsl:choose>
          <xsl:when test="count(exslt:node-set($income_summary)/income_item/*/item_detail)>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$blok_count=1">
        <table>
          <xsl:for-each select="exslt:node-set($income_summary)/income_item/*/item_detail">
            <xsl:if test="(position( ) mod 2) = 1">
              <tr class="pay_tr_odd">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="(position( ) mod 2) = 0">
              <tr class="pay_tr_even">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
      </xsl:if>
    </div>      
  </xsl:template>
  
  <xsl:template name="DETAILS_DEDUCT">
    <!-- inside variable for inner xml -->
    <xsl:variable name="deduction_source">
      <xsl:variable name="ins_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_INS_SOURCE'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tax_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_TAX_SOURCE'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <income_item>
        <label_text>Income</label_text>
        <xsl:if test ="$tax_count=1">
           <ins_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_INS_SOURCE']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each> 
          </ins_item>
        </xsl:if>
        <xsl:if test ="$tax_count=1">
          <tax_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_TAX_SOURCE']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each>
          </tax_item>
        </xsl:if>
      </income_item>
    </xsl:variable>
    <!-- table -->
    <div>
      <xsl:variable name="blok_count">
        <xsl:choose>
          <xsl:when test="count(exslt:node-set($deduction_source)/income_item/*/item_detail)>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$blok_count=1">
        <table>
          <xsl:for-each select="exslt:node-set($deduction_source)/income_item/*/item_detail">
            <xsl:if test="(position( ) mod 2) = 1">
              <tr class="pay_tr_odd">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="(position( ) mod 2) = 0">
              <tr class="pay_tr_even">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template name="SUMMARY_DEDUCT">
    <!-- inside variable for inner xml -->
    <xsl:variable name="deduction_result">
      <xsl:variable name="ins_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_INS_RESULT'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tax_count">
        <xsl:choose>
          <xsl:when test="count(results/result/item[group/@vgrp_pos='VPAYGRP_TAX_RESULT'])>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <income_item>
        <label_text>Income</label_text>
        <xsl:if test ="$tax_count=1">
           <ins_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_INS_RESULT']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each> 
          </ins_item>
        </xsl:if>
        <xsl:if test ="$tax_count=1">
          <tax_item>
            <xsl:for-each select="results/result/item[group/@vgrp_pos='VPAYGRP_TAX_RESULT']">
              <item_detail>
                <label_text><xsl:value-of select="title"/></label_text>
                <value_text><xsl:value-of select="value"/></value_text>
              </item_detail>
            </xsl:for-each>
          </tax_item>
        </xsl:if>
      </income_item>
    </xsl:variable>
    <!-- table -->
    <div>
      <xsl:variable name="blok_count">
        <xsl:choose>
          <xsl:when test="count(exslt:node-set($deduction_result)/income_item/*/item_detail)>0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$blok_count=1">
        <table>
          <xsl:for-each select="exslt:node-set($deduction_result)/income_item/*/item_detail">
            <xsl:if test="(position( ) mod 2) = 1">
              <tr class="pay_tr_odd">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="(position( ) mod 2) = 0">
              <tr class="pay_tr_even">
                <td>
                  <xsl:value-of select="./label_text"/>
                </td>
                <td>
                  <xsl:value-of select="./value_text"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template name="SUMMARY_PAYMENT">
    <div>
      <table>
        <tr>
          <td>Gross income</td>
        </tr>
      </table>
      <table>
        <xsl:for-each select="results/result/item[@tag_name='TAG_INCOME_GROSS']">
          <tr class="pay_tr_odd">
            <td>
              <xsl:value-of select="title"/>
            </td>
            <td>
              <xsl:value-of select="value"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
     </div>
    <div>
      <table>
        <tr>
          <td>Netto income</td>
        </tr>
      </table>
      <table>
        <xsl:for-each select="results/result/item[@tag_name='TAG_INCOME_NETTO']">
          <tr class="pay_tr_odd">
            <td>
              <xsl:value-of select="title"/>
            </td>
            <td>
              <xsl:value-of select="value"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
     </div>
  </xsl:template>
  
  <xsl:template name="DETAILS">
    <div>
      <!-- xsl:value-of select="exslt:node-set($income_blok)" -->
    </div>
  </xsl:template>

  <xsl:template name="SIGNATURE">
  </xsl:template>

  <xsl:template name="FOOTNOTE">
  </xsl:template>

</xsl:stylesheet>