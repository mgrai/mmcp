# coding=utf-8
from django.db.models import Sum
from models import OrderLine
from document.models import DocumentLineItem


def getPurchasedQuantity(documentLineItem):
        total_quantity = OrderLine.objects.filter(documentLineItem__id = documentLineItem.id).aggregate(Sum('purchase_quantity'))
        return total_quantity['purchase_quantity__sum'] if total_quantity['purchase_quantity__sum'] is not None else ''        


def update_document_purch_status(document):
        status = getPurchasedStatus(document)
        document.purch_status = status
        document.save(update_fields=['purch_status'])
    
    
def getPurchasedStatus(document):
        documentLines = DocumentLineItem.objects.filter(document = document)
        status = '未采购'
        count = 0
        non_purchased_count = 0
        for documentLineItem in documentLines:
            #审批数量 为0 表示不用采购，当前状态为 采购完成
            if documentLineItem.audit_quantity == 0:
                count +=1
                non_purchased_count += 1
                continue
            
            #申请数量 为0 表示不用采购，当前状态为 采购完成
            if documentLineItem.expected_quantity is None or documentLineItem.expected_quantity == 0:
                count +=1
                non_purchased_count += 1
                continue
            
            quantity = getPurchasedQuantity(documentLineItem)
            if bool(quantity) and quantity > 0:
                #要求数量
                available_quantity = documentLineItem.expected_quantity
                
                #审批数量
                if documentLineItem.audit_quantity and documentLineItem.audit_quantity > 0:
                    available_quantity = documentLineItem.audit_quantity
                
                
                if available_quantity == quantity:
                    count += 1
                        
                #采购没有完成
                elif quantity < available_quantity:
                    status = '采购中'
                    break
            else:
                non_purchased_count += 1
            
        if count == len(documentLines):
            status = '采购完成' 
        elif count < len(documentLines) and count > 0:   
            status = '采购中' 
        
        if non_purchased_count == len(documentLines):
            status = '未采购'
        return status