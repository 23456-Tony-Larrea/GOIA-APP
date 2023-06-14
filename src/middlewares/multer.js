import multer from 'multer';
import path from 'path';
import fs from 'fs';

const createDir = (dir) => {
  return new Promise((resolve, reject) => {
    fs.mkdir(dir, { recursive: true }, (error) => {
      if (error) {
        reject(error);
      } else {
        resolve();
      }
    });
  });
};
const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    const dir = path.join(process.cwd(), '/src/public/uploads/');
    try {
      await createDir(dir);
      cb(null, dir);
    } catch (error) {
      cb(error, null);
    }
  },
  filename: (req, file, cb) => {
    const fileName = `${file.originalname}`;
    cb(null, fileName);
  },
});

export const upload = multer({
  storage,
  limits: { fileSize: 8000000 }
}).single('document');