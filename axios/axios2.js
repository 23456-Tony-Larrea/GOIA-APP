import axios from 'axios';
const BASE_URL = 'http://192.168.2.68:8080/testLumen/public';

const axiosInstance = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'POST, GET, PUT, DELETE, OPTIONS, HEAD, Authorization, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, Access-Control-Allow-Origin',
    'Content-Type': 'application/json',
  },
});

export default axiosInstance;