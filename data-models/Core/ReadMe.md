# Government Common Data Model - Core

# Releases
---

We highly recommend using the managed versions, which will allow you to easily update and uninstall the solution from your environment. If you need to modify or enhance the managed solution, you can can create a new solution, add the components to that solution and make changes as needed.

# Entity Relationship Diagram
---

```mermaid
graph TD
  Account(Account)
  Contact(Person)
  govcdm_Agreement(Agreement)
  govcdm_Analysis(Analysis)
  govcdm_clearancelevel(Clearance Level)
  govcdm_Competency(Competency)
  govcdm_ComplianceFramework(Compliance Framework)
  govcdm_ComplianceFrameworkCategory(Compliance Framework Category)
  govcdm_ComplianceRequirement(Compliance Requirement)
  govcdm_ContentTemplate(Content Template)
  govcdm_country(Country)
  govcdm_DiscussionItem(Discussion Item)
  govcdm_Document(Document)
  govcdm_fiscalperiod(Fiscal Period)
  govcdm_graderank(Grade-Rank)
  govcdm_Impact(Impact)
  govcdm_jobseries(Job Series)
  govcdm_JudicialDistrict(Judicial District)
  govcdm_LegalAmendment(Legal Amendment)
  govcdm_LegalAuthority(Legal Authority)
  govcdm_LegalCrossReference(Legal Cross-Reference)
  govcdm_Location(Location)
  govcdm_organizationinitiative(Organization Initiative)
  govcdm_organizationunit(Organization Unit)
  govcdm_organizationunittype(Organization Unit Type)
  govcdm_paygrade(Pay Grade)
  govcdm_personneltype(Personnel Type)
  govcdm_PrivacyConsent(Privacy Consent)
  govcdm_Product(Product)
  govcdm_reviewapprovaldecision(Review Approval Decision)
  govcdm_RiskItem(Risk Item)
  govcdm_SignatureApproval(Signature Approval)
  govcdm_stateorprovince(State or Province)
  SystemUser(User)
  govcdm_Agreement --> Account
  govcdm_ComplianceFramework --> Account
  govcdm_Product --> Account
  govcdm_LegalAuthority --> Account
  govcdm_Analysis --> Contact
  govcdm_SignatureApproval --> Contact
  govcdm_organizationunit --> Contact
  govcdm_reviewapprovaldecision --> Contact
  govcdm_SignatureApproval --> FileAttachment
  govcdm_Impact --> govcdm_Analysis
  govcdm_RiskItem --> govcdm_Analysis
  Contact --> govcdm_clearancelevel
  govcdm_Competency --> govcdm_Competency
  govcdm_ComplianceFrameworkCategory --> govcdm_ComplianceFramework
  govcdm_ComplianceRequirement --> govcdm_ComplianceFramework
  govcdm_ComplianceRequirement --> govcdm_ComplianceFrameworkCategory
  govcdm_ComplianceRequirement --> govcdm_ComplianceRequirement
  govcdm_Document --> govcdm_ContentTemplate
  Contact --> govcdm_country
  govcdm_Location --> govcdm_country
  govcdm_stateorprovince --> govcdm_country
  govcdm_DiscussionItem --> govcdm_DiscussionItem
  govcdm_LegalAmendment --> govcdm_Document
  govcdm_LegalAuthority --> govcdm_Document
  Contact --> govcdm_graderank
  govcdm_Impact --> govcdm_Impact
  Contact --> govcdm_jobseries
  govcdm_Analysis --> govcdm_LegalAuthority
  govcdm_ComplianceFramework --> govcdm_LegalAuthority
  govcdm_Impact --> govcdm_LegalAuthority
  govcdm_LegalAmendment --> govcdm_LegalAuthority
  govcdm_LegalCrossReference --> govcdm_LegalAuthority
  govcdm_LegalCrossReference --> govcdm_LegalAuthority
  govcdm_RiskItem --> govcdm_LegalAuthority
  govcdm_Location --> govcdm_Location
  govcdm_organizationinitiative --> govcdm_organizationinitiative
  govcdm_Analysis --> govcdm_organizationunit
  govcdm_Competency --> govcdm_organizationunit
  govcdm_Impact --> govcdm_organizationunit
  govcdm_organizationinitiative --> govcdm_organizationunit
  govcdm_organizationunit --> govcdm_organizationunit
  govcdm_RiskItem --> govcdm_organizationunit
  govcdm_organizationunit --> govcdm_organizationunittype
  govcdm_graderank --> govcdm_paygrade
  Contact --> govcdm_personneltype
  govcdm_Product --> govcdm_Product
  govcdm_RiskItem --> govcdm_RiskItem
  Contact --> govcdm_stateorprovince
  govcdm_Location --> govcdm_stateorprovince
  govcdm_Agreement --> TransactionCurrency
  govcdm_Product --> TransactionCurrency
```

# Account
---

**Metadata**

- Schema: Account

**Custom Fields**


# Person
---

**Metadata**

- Schema: Contact

**Custom Fields**

- Address Home Country
  - Type: Lookup
  - Schema: govcdm_addresshomecountry
- Address Home State
  - Type: Lookup
  - Schema: govcdm_addresshomestateorprovince
- Clearance Level
  - Type: Lookup
  - Schema: govcdm_clearancelevel
- Collaboration URL
  - Type: Nvarchar
  - Schema: govcdm_CollaborationURL
- Job Grade
  - Type: Lookup
  - Schema: govcdm_jobgrade
- Job Series
  - Type: Lookup
  - Schema: govcdm_jobseries
- Personnel Type
  - Type: Lookup
  - Schema: govcdm_personneltype
- User
  - Type: Lookup
  - Schema: govcdm_user

# Agreement
---

**Metadata**

- Schema: govcdm_Agreement

**Custom Fields**

- Agreement Number
  - Type: Nvarchar
  - Schema: govcdm_AgreementNumber
- Agreement Status
  - Type: Picklist
  - Schema: govcdm_AgreementStatus
- Agreement Type
  - Type: Picklist
  - Schema: govcdm_AgreementType
- Amount
  - Type: Money
  - Schema: govcdm_Amount
- Amount (Base)
  - Type: Money
  - Schema: govcdm_amount_Base
- Counterparty
  - Type: Lookup
  - Schema: govcdm_Counterparty
- Currency
  - Type: Lookup
  - Schema: TransactionCurrencyId
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- End Date
  - Type: Datetime
  - Schema: govcdm_EndDate
- Exchange Rate
  - Type: Decimal
  - Schema: ExchangeRate
- Is Binding
  - Type: Picklist
  - Schema: govcdm_IsBinding
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Start Date
  - Type: Datetime
  - Schema: govcdm_StartDate

# Analysis
---

**Metadata**

- Schema: govcdm_Analysis

**Custom Fields**

- Action Status
  - Type: Picklist
  - Schema: govcdm_ActionStatus
- Analysis From Date
  - Type: Datetime
  - Schema: govcdm_AnalysisFromDate
- Analysis To Date
  - Type: Datetime
  - Schema: govcdm_AnalysisToDate
- Assessment POC
  - Type: Lookup
  - Schema: govcdm_AssessmentPOC
- Details
  - Type: Ntext
  - Schema: govcdm_Details
- Legal Authority
  - Type: Lookup
  - Schema: govcdm_LegalAuthority
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Organization Unit
  - Type: Lookup
  - Schema: govcdm_OrganizationUnit
- Summary
  - Type: Ntext
  - Schema: govcdm_Summary

# Clearance Level
---

**Metadata**

- Schema: govcdm_clearancelevel

**Custom Fields**

- Abbreviation
  - Type: Nvarchar
  - Schema: govcdm_abbreviation
- Code
  - Type: Nvarchar
  - Schema: govcdm_code
- Description
  - Type: Nvarchar
  - Schema: govcdm_description
- Name
  - Type: Nvarchar
  - Schema: govcdm_name

# Competency
---

**Metadata**

- Schema: govcdm_Competency

**Custom Fields**

- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Organization Unit
  - Type: Lookup
  - Schema: govcdm_OrganizationUnit
- Parent Competency
  - Type: Lookup
  - Schema: govcdm_ParentCompetency

# Compliance Framework
---

**Metadata**

- Schema: govcdm_ComplianceFramework

**Custom Fields**

- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Primary Legal Authority
  - Type: Lookup
  - Schema: govcdm_PrimaryLegalAuthority
- Responsible Authority
  - Type: Lookup
  - Schema: govcdm_ResponsibleAuthority
- Title
  - Type: Nvarchar
  - Schema: govcdm_Title
- URL
  - Type: Nvarchar
  - Schema: govcdm_URL

# Compliance Framework Category
---

**Metadata**

- Schema: govcdm_ComplianceFrameworkCategory

**Custom Fields**

- Compliance Framework
  - Type: Lookup
  - Schema: govcdm_ComplianceFramework
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name

# Compliance Requirement
---

**Metadata**

- Schema: govcdm_ComplianceRequirement

**Custom Fields**

- Additional Guidelines
  - Type: Ntext
  - Schema: govcdm_AdditionalGuidelines
- Applicable When
  - Type: Ntext
  - Schema: govcdm_ApplicableWhen
- Compliance Framework
  - Type: Lookup
  - Schema: govcdm_ComplianceFramework
- Compliance Framework Category
  - Type: Lookup
  - Schema: govcdm_ComplianceFrameworkCategory
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Details
  - Type: Ntext
  - Schema: govcdm_Details
- Effective From Date
  - Type: Datetime
  - Schema: govcdm_EffectiveFromDate
- Effective To Date
  - Type: Datetime
  - Schema: govcdm_EffectiveToDate
- Expiration / Review Date
  - Type: Datetime
  - Schema: govcdm_ExpirationReviewDate
- Moniker
  - Type: Nvarchar
  - Schema: govcdm_Name
- Non-Compliance Risk Level
  - Type: Picklist
  - Schema: govcdm_NonComplianceRiskLevel
- Parent Compliance Requirement
  - Type: Lookup
  - Schema: govcdm_ParentComplianceRequirement
- Title
  - Type: Nvarchar
  - Schema: govcdm_Title
- URL
  - Type: Nvarchar
  - Schema: govcdm_URL

# Content Template
---

**Metadata**

- Schema: govcdm_ContentTemplate

**Custom Fields**

- Name
  - Type: Nvarchar
  - Schema: govcdm_Name

# Country
---

**Metadata**

- Schema: govcdm_country

**Custom Fields**

- Abbreviation
  - Type: Nvarchar
  - Schema: govcdm_abbreviation
- Name
  - Type: Nvarchar
  - Schema: govcdm_name

# Discussion Item
---

**Metadata**

- Schema: govcdm_DiscussionItem

**Custom Fields**

- Comment
  - Type: Ntext
  - Schema: govcdm_Comment
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Discussion Item
  - Type: Lookup
  - Schema: govcdm_ParentDiscussionItem

# Document
---

**Metadata**

- Schema: govcdm_Document

**Custom Fields**

- Approval Status
  - Type: Picklist
  - Schema: govcdm_ApprovalStatus
- Content Template
  - Type: Lookup
  - Schema: govcdm_ContentTemplate
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Document URL
  - Type: Nvarchar
  - Schema: govcdm_DocumentURL
- Keywords
  - Type: Ntext
  - Schema: govcdm_Keywords
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Virtual Record ID
  - Type: Nvarchar
  - Schema: govcdm_VirtualRecordID
- Virtual Record Type
  - Type: Nvarchar
  - Schema: govcdm_VirtualRecordType

# Fiscal Period
---

**Metadata**

- Schema: govcdm_fiscalperiod

**Custom Fields**

- End Date
  - Type: Datetime
  - Schema: govcdm_EndDate
- Name
  - Type: Nvarchar
  - Schema: govcdm_name
- Start Date
  - Type: Datetime
  - Schema: govcdm_StartDate

# Grade-Rank
---

**Metadata**

- Schema: govcdm_graderank

**Custom Fields**

- Abbreviation
  - Type: Nvarchar
  - Schema: govcdm_abbreviation
- Description
  - Type: Nvarchar
  - Schema: govcdm_description
- Name
  - Type: Nvarchar
  - Schema: govcdm_name
- Pay Grade
  - Type: Lookup
  - Schema: govcdm_paygrade

# Impact
---

**Metadata**

- Schema: govcdm_Impact

**Custom Fields**

- Action Status
  - Type: Picklist
  - Schema: govcdm_ActionStatus
- Analysis
  - Type: Lookup
  - Schema: govcdm_Analysis
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Evidence of Mitigation
  - Type: Ntext
  - Schema: govcdm_EvidenceofMitigation
- General Category
  - Type: Picklist
  - Schema: govcdm_GeneralCategory
- Identification Date
  - Type: Datetime
  - Schema: govcdm_IdentificationDate
- Impact Level
  - Type: Picklist
  - Schema: govcdm_ImpactLevel
- Impact Likelihood
  - Type: Picklist
  - Schema: govcdm_ImpactLikelihood
- Impact Relevance
  - Type: Picklist
  - Schema: govcdm_ImpactRelevance
- Legal Authority
  - Type: Lookup
  - Schema: govcdm_LegalAuthority
- Mitigation Plan
  - Type: Ntext
  - Schema: govcdm_MitigationPlan
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Organization Unit
  - Type: Lookup
  - Schema: govcdm_OrganizationUnit
- Parent Impact
  - Type: Lookup
  - Schema: govcdm_ParentImpact
- Review Date
  - Type: Datetime
  - Schema: govcdm_ReviewDate
- Target Mitigation Date
  - Type: Datetime
  - Schema: govcdm_TargetMitigationDate

# Job Series
---

**Metadata**

- Schema: govcdm_jobseries

**Custom Fields**

- Description
  - Type: Nvarchar
  - Schema: govcdm_description
- Name
  - Type: Nvarchar
  - Schema: govcdm_name
- Series Number
  - Type: Nvarchar
  - Schema: govcdm_seriesnumber

# Judicial District
---

**Metadata**

- Schema: govcdm_JudicialDistrict

**Custom Fields**

- Name
  - Type: Nvarchar
  - Schema: govcdm_Name

# Legal Amendment
---

**Metadata**

- Schema: govcdm_LegalAmendment

**Custom Fields**

- Amendment Date
  - Type: Datetime
  - Schema: govcdm_AmendmentDate
- Document
  - Type: Lookup
  - Schema: govcdm_Document
- Full Text URL
  - Type: Nvarchar
  - Schema: govcdm_FullTextURL
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Legal Authority
  - Type: Lookup
  - Schema: govcdm_ParentLegalAuthority
- Submission Type
  - Type: Picklist
  - Schema: govcdm_SubmissionType
- Summary of Change
  - Type: Ntext
  - Schema: govcdm_SummaryofChange

# Legal Authority
---

**Metadata**

- Schema: govcdm_LegalAuthority

**Custom Fields**

- Citation
  - Type: Nvarchar
  - Schema: govcdm_Citation
- Disposition Notes
  - Type: Ntext
  - Schema: govcdm_DispositionNotes
- Document
  - Type: Lookup
  - Schema: govcdm_Document
- Document Number
  - Type: Nvarchar
  - Schema: govcdm_DocumentNumber
- Effective Date
  - Type: Datetime
  - Schema: govcdm_EffectiveDate
- Executive Order Number
  - Type: Nvarchar
  - Schema: govcdm_ExecutiveOrderNumber
- Expiration Date
  - Type: Datetime
  - Schema: govcdm_ExpirationDate
- Full Text URL
  - Type: Nvarchar
  - Schema: govcdm_FullTextURL
- Issuing Body
  - Type: Lookup
  - Schema: govcdm_IssuingBody
- Jurisdiction Level
  - Type: Picklist
  - Schema: govcdm_JurisdictionLevel
- Legal Authority Status
  - Type: Picklist
  - Schema: govcdm_LegalAuthorityStatus
- Legal Authority Type
  - Type: Picklist
  - Schema: govcdm_LegalAuthorityType
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Public Doc URL
  - Type: Nvarchar
  - Schema: govcdm_PublicDocURL
- Publication Date
  - Type: Datetime
  - Schema: govcdm_PublicationDate
- Signing Date
  - Type: Datetime
  - Schema: govcdm_SigningDate
- Summary
  - Type: Ntext
  - Schema: govcdm_Summary
- Tags
  - Type: Ntext
  - Schema: govcdm_Tags

# Legal Cross-Reference
---

**Metadata**

- Schema: govcdm_LegalCrossReference

**Custom Fields**

- From Legal Authority
  - Type: Lookup
  - Schema: govcdm_FromLegalAuthority
- Legal Authority Impact
  - Type: Picklist
  - Schema: govcdm_LegalAuthorityImpact
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- To Legal Authority
  - Type: Lookup
  - Schema: govcdm_ToLegalAuthority

# Location
---

**Metadata**

- Schema: govcdm_Location

**Custom Fields**

- Abbreviation
  - Type: Nvarchar
  - Schema: govcdm_Abbreviation
- Address Line 1
  - Type: Nvarchar
  - Schema: govcdm_AddressLine1
- Address Line 2
  - Type: Nvarchar
  - Schema: govcdm_AddressLine2
- City
  - Type: Nvarchar
  - Schema: govcdm_City
- Country
  - Type: Lookup
  - Schema: govcdm_Country
- Main Phone
  - Type: Nvarchar
  - Schema: govcdm_MainPhone
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Location
  - Type: Lookup
  - Schema: govcdm_ParentLocation
- Postal Code
  - Type: Nvarchar
  - Schema: govcdm_PostalCode
- State or Province
  - Type: Lookup
  - Schema: govcdm_StateorProvince

# Organization Initiative
---

**Metadata**

- Schema: govcdm_organizationinitiative

**Custom Fields**

- Description
  - Type: Nvarchar
  - Schema: govcdm_description
- Name
  - Type: Nvarchar
  - Schema: govcdm_name
- Organization Unit
  - Type: Lookup
  - Schema: govcdm_organizationunit
- Parent Initiative
  - Type: Lookup
  - Schema: govcdm_parentinitiative

# Organization Unit
---

**Metadata**

- Schema: govcdm_organizationunit

**Custom Fields**

- Abbreviation
  - Type: Nvarchar
  - Schema: govcdm_abbreviation
- Description
  - Type: Nvarchar
  - Schema: govcdm_description
- Managed By
  - Type: Lookup
  - Schema: govcdm_managedby
- Name
  - Type: Nvarchar
  - Schema: govcdm_name
- Org Code
  - Type: Nvarchar
  - Schema: govcdm_orgcode
- Organization Unit Type
  - Type: Lookup
  - Schema: govcdm_organizationunittype
- Parent Organization Unit
  - Type: Lookup
  - Schema: govcdm_ParentOrganizationUnit

# Organization Unit Type
---

**Metadata**

- Schema: govcdm_organizationunittype

**Custom Fields**

- Name
  - Type: Nvarchar
  - Schema: govcdm_name

# Pay Grade
---

**Metadata**

- Schema: govcdm_paygrade

**Custom Fields**

- Name
  - Type: Nvarchar
  - Schema: govcdm_name

# Personnel Type
---

**Metadata**

- Schema: govcdm_personneltype

**Custom Fields**

- Name
  - Type: Nvarchar
  - Schema: govcdm_name

# Privacy Consent
---

**Metadata**

- Schema: govcdm_PrivacyConsent

**Custom Fields**

- Consent For
  - Type: Nvarchar
  - Schema: govcdm_ConsentFor
- Consent Signed On
  - Type: Datetime
  - Schema: govcdm_ConsentSignedOn
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name

# Product
---

**Metadata**

- Schema: govcdm_Product

**Custom Fields**

- Currency
  - Type: Lookup
  - Schema: TransactionCurrencyId
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Exchange Rate
  - Type: Decimal
  - Schema: ExchangeRate
- Manufacturer
  - Type: Lookup
  - Schema: govcdm_Manufacturer
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Product
  - Type: Lookup
  - Schema: govcdm_ParentProduct
- Product Number
  - Type: Nvarchar
  - Schema: govcdm_ProductNumber
- URL
  - Type: Nvarchar
  - Schema: govcdm_URL
- Unit Price
  - Type: Money
  - Schema: govcdm_UnitPrice
- Unit Price (Base)
  - Type: Money
  - Schema: govcdm_unitprice_Base
- Unit of Issue
  - Type: Picklist
  - Schema: govcdm_UnitofIssue

# Review Approval Decision
---

**Metadata**

- Schema: govcdm_reviewapprovaldecision

**Custom Fields**

- Approval Status
  - Type: Picklist
  - Schema: govcdm_ApprovalStatus
- Decision
  - Type: Picklist
  - Schema: govcdm_decision
- Decision Date
  - Type: Datetime
  - Schema: govcdm_decisiondate
- Due Date
  - Type: Datetime
  - Schema: govcdm_duedate
- Follow-Up Date
  - Type: Datetime
  - Schema: govcdm_followupdate
- Name
  - Type: Nvarchar
  - Schema: govcdm_name
- Requested Date
  - Type: Datetime
  - Schema: govcdm_requesteddate
- Requestor Comments
  - Type: Nvarchar
  - Schema: govcdm_requestorcomments
- Reviewer
  - Type: Lookup
  - Schema: govcdm_reviewer
- Reviewer Comments
  - Type: Nvarchar
  - Schema: govcdm_reviewercomments
- Reviewer Type
  - Type: Picklist
  - Schema: govcdm_reviewertype

# Risk Item
---

**Metadata**

- Schema: govcdm_RiskItem

**Custom Fields**

- Action Status
  - Type: Picklist
  - Schema: govcdm_ActionStatus
- Analysis
  - Type: Lookup
  - Schema: govcdm_Analysis
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Evidence of Mitigation
  - Type: Ntext
  - Schema: govcdm_EvidenceofMitigation
- Identification Date
  - Type: Datetime
  - Schema: govcdm_IdentificationDate
- Impact Description
  - Type: Ntext
  - Schema: govcdm_ImpactDescription
- Legal Authority
  - Type: Lookup
  - Schema: govcdm_LegalAuthority
- Mitigation Plan
  - Type: Ntext
  - Schema: govcdm_MitigationPlan
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Organization Unit
  - Type: Lookup
  - Schema: govcdm_OrganizationUnit
- Parent Risk Item
  - Type: Lookup
  - Schema: govcdm_ParentRiskItem
- Review Date
  - Type: Datetime
  - Schema: govcdm_ReviewDate
- Risk General Category
  - Type: Picklist
  - Schema: govcdm_RiskGeneralCategory
- Risk Level
  - Type: Picklist
  - Schema: govcdm_RiskLevel
- Risk Likelihood
  - Type: Picklist
  - Schema: govcdm_RiskLikelihood
- Target Mitigation Date
  - Type: Datetime
  - Schema: govcdm_TargetMitigationDate

# Signature Approval
---

**Metadata**

- Schema: govcdm_SignatureApproval

**Custom Fields**

- Approval Status
  - Type: Picklist
  - Schema: govcdm_ApprovalStatus
- Comments
  - Type: Ntext
  - Schema: govcdm_Comments
- E-Confirmation
  - Type: Picklist
  - Schema: govcdm_EConfirmation
- E-Signature
  - Type: Nvarchar
  - Schema: govcdm_ESignature
- E-Signature File
  - Type: File
  - Schema: govcdm_ESignatureFile
- E-Signature Image
  - Type: Image
  - Schema: govcdm_ESignatureImage
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Signed Approved By
  - Type: Lookup
  - Schema: govcdm_SignedApprovedBy
- Signed Approved Date Time
  - Type: Datetime
  - Schema: govcdm_SignedApprovedDateTime

# State or Province
---

**Metadata**

- Schema: govcdm_stateorprovince

**Custom Fields**

- Abbreviation
  - Type: Nvarchar
  - Schema: govcdm_abbreviation
- Country
  - Type: Lookup
  - Schema: govcdm_country
- Name
  - Type: Nvarchar
  - Schema: govcdm_name

# User
---

**Metadata**

- Schema: SystemUser

**Custom Fields**

