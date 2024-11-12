# Government Common Data Model - Core

We highly recommend using the managed versions, which will allow you to easily update and uninstall the solution from your environment. If you need to modify or enhance the managed solution, you can can create a new solution, add the components to that solution and make changes as needed.

# Entity Relationship Diagram
---
<img width="1651" alt="384500833-589f6476-b704-4e7f-9ffc-1ab05be82ef4" src="https://github.com/user-attachments/assets/3d5d1cc9-8525-453d-a7e0-61065920bceb">

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
- Mitigation Plan
  - Type: Ntext
  - Schema: govcdm_MitigationPlan
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
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

