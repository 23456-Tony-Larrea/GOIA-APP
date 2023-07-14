import { Component, OnInit } from '@angular/core';
import { BluetoothSerial } from '@awesome-cordova-plugins/bluetooth-serial/ngx';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage implements OnInit {

  devices: any[] = []; // Lista de dispositivos Bluetooth emparejados

  constructor(private bluetoothSerial: BluetoothSerial) { }

  ngOnInit() {
    // Obtener la lista de dispositivos Bluetooth emparejados al cargar el componente
    this.getPairedDevices();
  }

  getPairedDevices() {
    this.bluetoothSerial.list().then((devices) => {
      this.devices = devices;
    }).catch((error) => {
      console.error('Error al obtener la lista de dispositivos Bluetooth emparejados:', error);
    });
  }
}
