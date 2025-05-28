public with sharing class geoController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Double> getGeoInfo(Id recordId) {
        Map<String, Double> result = new Map<String, Double>();

        String prefix = String.valueOf(recordId).substring(0, 3);
        String sObjectType = getSObjectTypeFromPrefix(prefix);

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

            result.put('pickupLat', record.rcv_geo__Latitude__s);
            result.put('pickupLng', record.rcv_geo__Longitude__s);
            result.put('installLat', record.inst_geo__Latitude__s);
            result.put('installLng', record.inst_geo__Longitude__s);

        } else if (sObjectType == 'shipping_history__c') {
            shipping_history__c record = [
                SELECT geo__Latitude__s, geo__Longitude__s
                FROM shipping_history__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            // 배송 이력은 설치 주소만 사용 (pickup 없음)
            result.put('installLat', record.geo__Latitude__s);
            result.put('installLng', record.geo__Longitude__s);
        }

        return result;
    }

    private static String getSObjectTypeFromPrefix(String prefix) {
        // describe로 prefix -> sObjectName 매핑
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (String name : gd.keySet()) {
            if (gd.get(name).getDescribe().getKeyPrefix() == prefix) {
                return name;
            }
        }
        return null;
    }
}