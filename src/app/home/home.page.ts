import { Component} from '@angular/core';
import { BluetoothSerial } from '@awesome-cordova-plugins/bluetooth-serial/ngx';
import {AlertController} from '@ionic/angular'
@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {
  Devices: any[] = [];
constructor(private bluetoohSerial:BluetoothSerial, private alertController:AlertController){}
activateBluetooh(){
  this.bluetoohSerial.enable().then(
    (success)=>{
    this.isEnable("isOn")
    this.listDevice()      
    },error=>{
      this.isEnable("isOff")
    }
  )
}
connectBluetooh(address:any){
  this.bluetoohSerial.connect(address).subscribe(success=>{
    this.deviceConnected()
  },error=>
    console.log("error")
  )
}

deviceConnected(){
  this.bluetoohSerial.subscribe('/n').subscribe(success=>{
    this.hundler(success)
  })
}
hundler(value:any){
  console.log(value)
}
sendData(){
  this.bluetoohSerial.write('$11111#').then(success=>{
    console.log('success')
  },error=>{
    console.log('error')
  })
}
listDevice(){
  this.bluetoohSerial.list().then(
    (success)=>{
      this.Devices=success
    },error=>{
      console.log(error)
    }
  )
}
Disconnected(){
  this.bluetoohSerial.disconnect()
  console.log('dispositivo desconectado')
}
async isEnable(msg:any){
  const alert=await this.alertController.create({
    header:'Bluetooth',
    message:msg,
    buttons:[
      {
        text:'No',
        role:'cancel',
        handler:()=>{
          console.log('No')
        }
      },
      {
        text:'Si',
        handler:()=>{
          console.log('Si')
        }
      }
    ]
  })

}


}
