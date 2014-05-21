# encoding: utf-8
ROLE_DEFINITION = [:role_super, :role_admin, :role_dev, :role_fin, :role_plm, :role_sales, :role_material_controller, :role_service, :role_others]
COMPONENT_CATEGORY_MAP = [:level0, :level1, :level2, :level3]
COMPANY_STATUS_DEFINITION = [:company_active, :company_outdated, :company_transient]
COURIER_DEFINTION = { "自提" => 1, "亲自送货" => 2, "众邦" => 3, "圆通" => 4, "顺丰" => 5, "其他" => 6 }
#STATUS_DEFINITION = [:status_pending_approval, :status_active, :status_transient, :status_outdated]
#BOM_STATUS_DEFINITION = [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated]
TRANSACTION_DEFINITION = [:buy_in, :in_manufacturing, :used, :manual_adjustment, :obsolete]
DEFAULT_STATUS_DEFINITION = [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated]
PRODUCT_STATUS_DEFINITION = [:status_rnd, :status_npi, :status_ga, :status_eol, :status_closed]
PRODUCTION_TYPE_DEFINITION = [:TRIAL_PRODUCTION, :MASSIVE_PRODUCTION, :TEST_PRODUCTION]
MANUFACTURING_PROCESS_DEFINITION = [:LEAD_FREE, :LEAD, :MIXTURE]
RF_FREQ_DEFINITION = [:GSM_DUAL_BAND, :GSM_QUAD_BAND, :GSM_AND_TDSCDMA]