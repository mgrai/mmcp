
DROP PROCEDURE IF EXISTS assign_group_privilege;

DELIMITER $$

CREATE PROCEDURE assign_group_privilege(v_company_id INT, v_group_name varchar(30))
BEGIN
	DECLARE done int;
	DECLARE v_group_id int;

	DECLARE cursor_group CURSOR FOR SELECT id FROM auth_group where name = CONCAT(v_group_name, v_company_id);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	OPEN cursor_group;
	out_loop:
	LOOP
	  FETCH cursor_group INTO v_group_id;
	  IF done = 1 THEN
	    LEAVE out_loop;
	  END IF;
	  
	  IF v_group_name = '预算部门'	THEN
	  
	  	 delete from auth_group_permissions where group_id = v_group_id;
	  	 -- 增加 项目 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 61);
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 62);
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 63);
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 71);
	  	 
	  	 -- 增加  价格查询 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 300);
	  	 
	  	 -- 增加 项目材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 64);
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 65);
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 66);
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 72);
		
		-- 增加 查看材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 58);
		
		
		-- 增加 查看 工程用量， 付款汇总 等报表
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 106);
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- for view
		
		
	
	  END IF;
	  
	  IF v_group_name = '预算部门经理'	THEN
	  
	  	delete from auth_group_permissions where group_id = v_group_id;
	  	 
	  	-- 与我相关
		-- 增加  待我处理， 已处理 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 119); -- change_item
		
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2001); -- handle_item
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2002); -- handled_item
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 77);   -- change_documentlineitem
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 128); -- view_taskhistory
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 140); -- for change_payment
		
	  	 -- 项目管理 
	  	 -- 增加 项目 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 61); -- add_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 62); -- change_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 63); -- delete_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 71); -- view_project
	  	 
	  	 -- 增加  价格查询 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2000); -- search_price_orderline
	  	 
	  	 -- 增加 项目材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 64); -- add_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 65); -- change_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 66); -- delete_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 72); -- view_projectmaterial
		
		-- 材料管理 
		-- 增加 查看材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 58); -- view_material
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 55); -- view_vendor
		
		-- 付款管理
		-- 增加 查看付款单 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 146); -- view_dopayemnt
		
		-- 报表管理 
		-- 增加 查看 工程用量， 付款汇总 等报表
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 104); -- view_checkaccount
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 105); -- view_checkaccountdetail
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 106); -- view_order
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- view_receivingline
		
	  END IF;
	  
	  IF v_group_name = '工程部门'	THEN
	  
	  	 delete from auth_group_permissions where group_id = v_group_id;
	  	 
	  	 -- 与我相关
	  	 -- 增加 我的申请 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 132); -- for view
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 128); -- for view_taskhistory 
		
		
		 -- 项目管理 
	  	 -- 增加 项目 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 71); -- for view
	  	 
	  	 -- 增加 项目材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 72); -- for view
		
		-- 材料申请
		-- 增加 材料选择 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 68); -- for change_selectedlineitem
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 69); -- for delete_selectedlineitem
		
		-- 增加 材料申请单 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 74); -- for change document
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 79); -- for view document
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 75); -- for delete document
		
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 77); -- for delete documentline
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 78); -- for delete documentline
		
		-- 报表管理 
		-- 到货单
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- for view
		
		
	 END IF;
	 
	 IF v_group_name = '采购部门'	THEN
	  
	  	 delete from auth_group_permissions where group_id = v_group_id;
	  	 
	  	 -- 与我相关
	  	 -- 增加 我的申请 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 132); -- for view
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 128); -- for view_taskhistory 
		
		
		 -- 项目管理 
	  	 -- 增加 项目 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 71); -- for view
	  	 
	  	 -- 增加 项目材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 72); -- for view
		
		-- 材料管理 
		-- 供应商
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 58); -- view_material
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 52); -- for add_vendor
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 53); -- for change_vendor
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 54); -- for delete_vendor
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 55); -- for view_vendor
		
		-- 采购管理 
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 106); -- for view_order
		-- 要料单
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 77); -- for change_documentlineitem
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 74); -- for change_document
		
		-- 采购单
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 85); -- for change_order
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 86); -- for delete_order
		
		-- 采购单名细
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 88); -- for change_orderline
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 89); -- for delete_orderline
		
		-- 到货单名细
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- for view_receivingline
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 94); -- for change_receivingline
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 95); -- for delete_receivingline
		
		-- 发票
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 99); -- for add_invoice
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 100); -- for change_invoice
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 101); -- for delete_invoice
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 103); -- for view_invoice
		
		-- 付款管理
		-- 付款申请
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 139); -- for add_payment
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 140); -- for change_payment
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 141); -- for delete_payment
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 145); -- for view_payment
		
		-- 付款单
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 142); -- for add_dopayemnt
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 143); -- for change_dopayemnt
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 144); -- for delete_dopayemnt
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 146); -- for view_dopayemnt
		
		-- 支付方式
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 133); -- for add_paymenttype
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 134); -- for change_paymenttype
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 135); -- for delete_paymenttype
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 147); -- for view_paymenttype
		
		-- 款项属性
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 136); -- for add_paymentproperty
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 137); -- for change_paymentproperty
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 138); -- for delete_paymentproperty
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 148); -- for view_paymentproperty
		
		
		-- 报表管理 
		-- 对帐单
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 104); -- view_checkaccount
		-- 对帐名细
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 105); -- view_checkaccountdetail
		
		-- 基础值设置
		-- 项目设置
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 149); -- for add_projectsetting
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 150); -- for change_projectsetting
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 151); -- for delete_projectsetting
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 156); -- for view_projectsetting
		
		-- 供应商设置
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 152); -- for add_vendorsetting
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 153); -- for change_vendorsetting
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 154); -- for delete_vendorsetting
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 155); -- for view_vendorsetting
		
		-- 采购单注意事项
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 81); -- for add_ordernote
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 82); -- for change_ordernote
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 83); -- for delete_ordernote
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 108); -- for view_ordernote
		
		
		
	 END IF;
	 
	 IF v_group_name = '副总经理'	THEN
	  
	  	delete from auth_group_permissions where group_id = v_group_id;
	  	 
	  	-- 与我相关
		-- 增加  待我处理， 已处理 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 119); -- change_item
		
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2001); -- handle_item
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2002); -- handled_item
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 77);   -- change_documentlineitem
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 128); -- view_taskhistory
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 140); -- for change_payment
		
	  	 -- 项目管理 
	  	 -- 增加 项目 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 61); -- add_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 62); -- change_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 63); -- delete_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 71); -- view_project
	  	 
	  	 -- 增加  价格查询 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2000); -- search_price_orderline
	  	 
	  	 -- 增加 项目材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 64); -- add_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 65); -- change_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 66); -- delete_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 72); -- view_projectmaterial
		
		-- 材料管理 
		-- 增加 查看材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 58); -- view_material
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 55); -- view_vendor
		
		-- 付款管理
		-- 增加 查看付款单 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 146); -- view_dopayemnt
		
		-- 报表管理 
		-- 增加 查看 工程用量， 付款汇总 等报表
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 104); -- view_checkaccount
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 105); -- view_checkaccountdetail
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 106); -- view_order
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- view_receivingline
		
	  END IF;
	  
	  IF v_group_name = '总经理'	THEN
	  
	  	delete from auth_group_permissions where group_id = v_group_id;
	  	 
	  	-- 与我相关
		-- 增加  待我处理， 已处理 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 119); -- change_item
		
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2001); -- handle_item
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2002); -- handled_item
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 77);   -- change_documentlineitem
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 128); -- view_taskhistory
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 140); -- for change_payment
		
	  	 -- 项目管理 
	  	 -- 增加 项目 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 61); -- add_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 62); -- change_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 63); -- delete_project
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 71); -- view_project
	  	 
	  	 -- 增加  价格查询 权限
	  	 insert auth_group_permissions (group_id, permission_id) values(v_group_id, 2000); -- search_price_orderline
	  	 
	  	 -- 增加 项目材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 64); -- add_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 65); -- change_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 66); -- delete_projectmaterial
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 72); -- view_projectmaterial
		
		-- 材料管理 
		-- 增加 查看材料 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 58); -- view_material
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 55); -- view_vendor
		
		-- 付款管理
		-- 增加 查看付款单 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 146); -- view_dopayemnt
		
		-- 报表管理 
		-- 增加 查看 工程用量， 付款汇总 等报表
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 104); -- view_checkaccount
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 105); -- view_checkaccountdetail
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 106); -- view_order
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- view_receivingline
		
	  END IF;
	  
	  IF v_group_name = '财务部门'	THEN
	  
	  	delete from auth_group_permissions where group_id = v_group_id;
	  	-- 采购管理
	  	-- 发票
	  	insert auth_group_permissions (group_id, permission_id) values(v_group_id, 103); -- for view_invoice
	  	insert auth_group_permissions (group_id, permission_id) values(v_group_id, 100); -- for change_invoice
	  	
		-- 付款管理
		-- 增加 查看付款单 权限
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 128); -- view_taskhistory
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 146); -- view_dopayemnt
		
		-- 报表管理 
		-- 增加 查看 工程用量， 付款汇总 等报表
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 104); -- view_checkaccount
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 105); -- view_checkaccountdetail
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 106); -- view_order
		insert auth_group_permissions (group_id, permission_id) values(v_group_id, 102); -- view_receivingline
		
	  END IF;
	 
	 SET done=0;
	END LOOP out_loop;
    CLOSE cursor_group;
	
END 