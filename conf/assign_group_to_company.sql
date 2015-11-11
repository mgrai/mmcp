
DROP PROCEDURE IF EXISTS assign_group_to_company;

DELIMITER $$

CREATE PROCEDURE assign_group_to_company(v_company_id INT, v_group_name varchar(30))
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
	  
	  delete from xadmin_companygroup where group_ptr_id = v_group_id;
	  insert xadmin_companygroup (group_ptr_id, company_id) values(v_group_id, v_company_id);
	  
	  
	 SET done=0;
	END LOOP out_loop;
    CLOSE cursor_group;
	
END 