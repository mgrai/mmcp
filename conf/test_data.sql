

INSERT INTO `workflow_route` VALUES (1,'项目材料申请',100,1),(2,'付款申请',100,1);

INSERT INTO `workflow_actor` VALUES (1,1,'预算部门经理审批',1),
									(2,1,'副总经理审批',2),
									(3,1,'总经理审批',3),
									
									(4,2,'预算部门经理审批',1),
									(5,2,'副总经理审批',2),
									(6,2,'总经理审批',3);




SELECT * FROM mmcp.auth_permission where name like '%单据名细%'

call create_admin_user_privilege(1, 2);