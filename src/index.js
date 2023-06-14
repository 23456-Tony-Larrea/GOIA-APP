import app from './app.js'
import {sequelize} from './database/database.js'
import './models/Users.js'
import './models/Department.js'
import './models/Users_Department.js'
import './models/Role.js'
import './models/Car.js'
import './models/RolePermission.js'

async function main() {
    try {
        await sequelize.sync({ force:false});
        console.log('Database is connected');
        await app.listen(app.get('port'));
        console.log('Server on port', app.get('port'),'192.168.2.69');
      } catch (error) {
        console.log(error);
      }
}
export default main();
