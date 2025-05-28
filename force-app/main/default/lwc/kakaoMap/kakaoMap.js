import { LightningElement, api, wire } from 'lwc';
import getGeoInfo from '@salesforce/apex/GeoController.getGeoInfo';

export default class KakaoMap extends LightningElement {
    @api recordId;

    pickupLat;
    pickupLng;
    installLat;
    installLng;

    @wire(getGeoInfo, { recordId: '$recordId' })
    wiredGeoInfo({ data, error }) {
        if (data) {
            this.pickupLat = data.pickupLat;
            this.pickupLng = data.pickupLng;
            this.installLat = data.installLat;
            this.installLng = data.installLng;
        } else if (error) {
            console.error('좌표 정보 가져오기 실패:', error);
        }
    }

    get vfUrl() {
        const hasPickup = this.pickupLat && this.pickupLng;
        const hasInstall = this.installLat && this.installLng;
    
        if (!hasPickup && !hasInstall) {
            return ''; // 둘 다 없으면 표시 X
        }
    
        let url = '/apex/KakaoMapVF?';
        if (hasPickup) {
            url += `pickupLat=${this.pickupLat}&pickupLng=${this.pickupLng}&`;
        }
        if (hasInstall) {
            url += `installLat=${this.installLat}&installLng=${this.installLng}`;
        }
    
        return url;
    }
    
}
