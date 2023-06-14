import { Evidence, Cars } from "../models"; // Importa los modelos necesarios

export const createEvidence = async (req, res) => {
  const { id } = req.params; // Obtiene el ID del coche desde los parámetros de la URL
  const image = req.file.path;

  try {
    const newEvidence = await Evidence.create({ image });

    // Actualiza el ID de evidencia en el coche correspondiente
    await Cars.update({ id_evidence: newEvidence.id }, { where: { id } });

    return res.json({
      message: "Evidence created and car updated successfully",
      data: newEvidence,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message: "Something went wrong",
      data: {},
    });
  }
};

