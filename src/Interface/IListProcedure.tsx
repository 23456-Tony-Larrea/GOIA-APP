  export interface IDefecto {
      codigo: number;
      abreviatura: string;
      descripcion: string;
      numero: string;
      codigo_as400: string;
    }
  
  export interface IListProcedure  {
    codigo: number;
    numero: number;
    familia: number;
    subfamilia: string;
    abreviatura: string;
    abreviatura_descripcion: string;
    subfamilia_descripcion: string;
    categoria: string;
    categoria_abreviatura: string;
    categoria_descripcion: string;
    procedimiento: string;
    defectos: IDefecto[];
    defectoEncontrado: {
      numero: string;
      abreviatura: string;
      descripcion: string;
      codigo_as400: string;
      calificacion: string;
      ubicacion: string;
      observacion: string;
    };
  }
  