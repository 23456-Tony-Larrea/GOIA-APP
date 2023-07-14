import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
apiUrl='http://192.168.2.69:4003/'
  constructor(private http: HttpClient) {}
  login(email: string, password: string) {
    const data = {
      username: email,
      password: password
    };
    return this.http.post(`${this.apiUrl}login`, data);
  }
}
