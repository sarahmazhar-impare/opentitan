// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class keymgr_env_cfg extends cip_base_env_cfg #(.RAL_T(keymgr_reg_block));

  rand keymgr_kmac_agent_cfg m_keymgr_kmac_agent_cfg;
  rand push_pull_agent_cfg#(.DeviceDataWidth(EDN_DATA_SIZE)) m_edn_pull_agent_cfg;

  // interface for input data from LC, OTP and flash
  keymgr_vif keymgr_vif;

  `uvm_object_utils_begin(keymgr_env_cfg)
  `uvm_object_utils_end

  `uvm_object_new

  virtual function void initialize(bit [31:0] csr_base_addr = '1);
    list_of_alerts = keymgr_env_pkg::LIST_OF_ALERTS;
    super.initialize(csr_base_addr);

    m_keymgr_kmac_agent_cfg = keymgr_kmac_agent_cfg::type_id::create("m_keymgr_kmac_agent_cfg");
    m_keymgr_kmac_agent_cfg.if_mode = dv_utils_pkg::Device;
    m_edn_pull_agent_cfg = push_pull_agent_cfg#(.DeviceDataWidth(EDN_DATA_SIZE))::type_id::create
                           ("m_edn_pull_agent_cfg");
    m_edn_pull_agent_cfg.agent_type = PullAgent;
    m_edn_pull_agent_cfg.if_mode    = Device;

    // set num_interrupts & num_alerts
    begin
      uvm_reg rg = ral.get_reg_by_name("intr_state");
      if (rg != null) begin
        num_interrupts = ral.intr_state.get_n_used_bits();
      end
    end
  endfunction

endclass
