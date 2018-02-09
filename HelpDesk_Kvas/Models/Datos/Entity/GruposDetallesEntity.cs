﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HelpDesk_Kvas.Models.Datos.Entity
{
    public class GruposDetallesEntity : GruposEntity
    {
        [Key]
        public int IdGrupoDetalle { get; set; }

        //[Required]
        //[StringLength(50)]
        //[Display(Name = "Nombre:")]
        //public string Titulo { get; set; }

        //[Required]
        //[StringLength(100)]
        //[Display(Name = "Descripcion Completa:")]
        //public string Descripcion { get; set; }

        [Display(Name = "Orden:")]
        public int Orden { get; set; }
        
        //[Display(Name = "Entidad:")]
        //public int? IdGrupo { get; set; }
        
        //[Display(Name = "Categoria Padre:")]
        //public int? IdPadre { get; set; }

        //[StringLength(30)]
        //[Display(Name = "Icono:")]
        //public string Icono { get; set; }

        [Required]
        [StringLength(30)]
        [Display(Name = "Url de la Entidad:")]
        public string UrlDetalle { get; set; }

        //[Display(Name = "Estatus:")]
        //public bool Estatus { get; set; }

        //[DataType(DataType.DateTime)]
        //[Display(Name = "Fecha de Registro:")]
        //public DateTime FechaRegistro { get; set; }

        //public int Mensaje { get; set; }
    }

    public class GruposDetallesView : GruposDetallesEntity
    {   
        [Display(Name = "Entidad:")]
        public string Grupo { get; set; }
        
        [Display(Name = "Grupo Superior:")]
        public string Padre { get; set; }
    }
}