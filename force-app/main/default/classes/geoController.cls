public with sharing class geoController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Double> getGeoInfo(Id recordId) {
        Map<String, Double> result = new Map<String, Double>();

        String sObjectType = recordId.getSObjectType().getDescribe().getName();

        if (sObjectType == 'move_history__c') {
            move_history__c record = [
                SELECT
                    rcv_geo__Latitude__s,
                    rcv_geo__Longitude__s,
                    inst_geo__Latitude__s,
                    inst_geo__Longitude__s
                FROM move_history__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            if (record != null) {
                result.put('pickupLat', record.rcv_geo__Latitude__s);
                result.put('pickupLng', record.rcv_geo__Longitude__s);
                result.put('installLat', record.inst_geo__Latitude__s);
                result.put('installLng', record.inst_geo__Longitude__s);
            }

        } else if (sObjectType == 'shipping_history__c') {
            shipping_history__c record = [
                SELECT geo__Latitude__s, geo__Longitude__s
                FROM shipping_history__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            if (record != null) {
                result.put('installLat', record.geo__Latitude__s);
                result.put('installLng', record.geo__Longitude__s);
            }

        } else if (sObjectType == 'gift_history__c') {
            gift_history__c record = [
                SELECT geo__Latitude__s, geo__Longitude__s
                FROM gift_history__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            if (record != null) {
                result.put('installLat', record.geo__Latitude__s);
                result.put('installLng', record.geo__Longitude__s);
            }
        }

        return result;
    }
}
