DROP PROCEDURE IF EXISTS create_admin_user_privilege;

DELIMITER $$

CREATE PROCEDURE create_admin_user_privilege(v_company_id INT, v_employee_id INT)
BEGIN
	DECLARE ESTIMATE_GROUP_MANAGER varchar(30);
	DECLARE PRCHASE_GROUP_MANAGER varchar(30);
	DECLARE ACCONT_GROUP_MANAGER varchar(30);
	DECLARE VICE_GENERAL_MANAGER varchar(30);
	DECLARE GENERAL_MANAGER varchar(30);
	DECLARE ACCONT_GROUP varchar(30);
	DECLARE PROJECT_GROUP varchar(30);
	DECLARE PRCHASE_GROUP varchar(30);
	DECLARE ESTIMATE_GROUP varchar(30);
	
	DECLARE v_group_id INT;
	
	-- 公司admin的权限分配----------------------------------------------------------------------------------
	-- 系统管理----------------------------------------------------------------------------------
	-- 增加 部门 权限
    delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (166, 167, 168);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 166);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 167);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 168);
	
	-- 增加 查看权限 的权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id = 8;
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 8);
	
	-- 增加 用户 权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (32, 33, 34, 35);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 32);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 33);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 34);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 35);
	
	
	
	-- 工作流----------------------------------------------------------------------------------
	-- 增加 流程 权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (109, 110, 111, 131);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 109);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 110);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 111);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 131);
	 
	-- 增加 步骤 权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (112, 113, 114, 129);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 112);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 113);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 114);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 129);
	
	
	-- 增加 步骤处理人 权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (115, 116, 117, 130);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 115);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 116);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 117);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 130);
	
	-- 项目管理----------------------------------------------------------------------------------
	-- 增加 项目 权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (61, 62, 63, 71);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 61);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 62);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 63);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 71);
	
	-- 增加 项目材料 权限
	delete from company_employee_user_permissions where employee_id = v_employee_id and permission_id in (64, 65, 66, 72);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 64);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 65);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 66);
	insert company_employee_user_permissions (employee_id, permission_id) values(v_employee_id, 72);
	
	
	
	-- 增加 公司下面的部门----------------------------------------------------------------------------------
	Set ESTIMATE_GROUP_MANAGER = '预算部门经理';
	Set PRCHASE_GROUP_MANAGER = '采购部门经理';
	Set ACCONT_GROUP_MANAGER = '财务部门经理';
	Set VICE_GENERAL_MANAGER = '副总经理';
	Set GENERAL_MANAGER = '总经理';

	Set ACCONT_GROUP = '财务部门';
	Set PROJECT_GROUP = '工程部门';
	Set PRCHASE_GROUP = '采购部门';
	Set ESTIMATE_GROUP = '预算部门';

	delete from auth_group where name in (CONCAT(ESTIMATE_GROUP_MANAGER, v_company_id),
										CONCAT(PRCHASE_GROUP_MANAGER, v_company_id),
										CONCAT(ACCONT_GROUP_MANAGER, v_company_id),
										CONCAT(VICE_GENERAL_MANAGER, v_company_id),
										CONCAT(GENERAL_MANAGER, v_company_id),
										CONCAT(ACCONT_GROUP, v_company_id),
										CONCAT(PROJECT_GROUP, v_company_id),
										CONCAT(PRCHASE_GROUP, v_company_id),
										CONCAT(ESTIMATE_GROUP, v_company_id)
										);
										
	insert auth_group (name) values(CONCAT(ESTIMATE_GROUP_MANAGER, v_company_id));
	insert auth_group (name) values(CONCAT(PRCHASE_GROUP_MANAGER, v_company_id));
	insert auth_group (name) values(CONCAT(ACCONT_GROUP_MANAGER, v_company_id));
	insert auth_group (name) values(CONCAT(VICE_GENERAL_MANAGER, v_company_id));
	insert auth_group (name) values(CONCAT(GENERAL_MANAGER, v_company_id));
	insert auth_group (name) values(CONCAT(ACCONT_GROUP, v_company_id));
	insert auth_group (name) values(CONCAT(PROJECT_GROUP, v_company_id));
	insert auth_group (name) values(CONCAT(PRCHASE_GROUP, v_company_id));
	insert auth_group (name) values(CONCAT(ESTIMATE_GROUP, v_company_id));
	
	-- 把部门分配到公司下面
	Call assign_group_to_company(v_company_id, ESTIMATE_GROUP_MANAGER);	
	Call assign_group_to_company(v_company_id, PRCHASE_GROUP_MANAGER);	
	Call assign_group_to_company(v_company_id, ACCONT_GROUP_MANAGER);	
	Call assign_group_to_company(v_company_id, VICE_GENERAL_MANAGER);	
	Call assign_group_to_company(v_company_id, GENERAL_MANAGER);	
	Call assign_group_to_company(v_company_id, ACCONT_GROUP);	
	Call assign_group_to_company(v_company_id, PROJECT_GROUP);	
	Call assign_group_to_company(v_company_id, PRCHASE_GROUP);	
	Call assign_group_to_company(v_company_id, ESTIMATE_GROUP);	
	
	-- 分配各部门的权限
	Call assign_group_privilege(v_company_id, ESTIMATE_GROUP_MANAGER);	
	Call assign_group_privilege(v_company_id, PRCHASE_GROUP_MANAGER);	
	Call assign_group_privilege(v_company_id, ACCONT_GROUP_MANAGER);	
	Call assign_group_privilege(v_company_id, VICE_GENERAL_MANAGER);	
	Call assign_group_privilege(v_company_id, GENERAL_MANAGER);	
	Call assign_group_privilege(v_company_id, ACCONT_GROUP);	
	Call assign_group_privilege(v_company_id, PROJECT_GROUP);	
	Call assign_group_privilege(v_company_id, PRCHASE_GROUP);	
	Call assign_group_privilege(v_company_id, ESTIMATE_GROUP);	
	
	
	
	

	
END