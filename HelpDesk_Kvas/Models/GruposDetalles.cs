namespace HelpDesk_Kvas.Models
{
    using HelpDesk_Kvas.Seguridad.Permisos;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class GruposDetalles
    {
        public GruposDetalles()
        {
            ICollection = new HashSet<GruposDetalles>();
            Permisos_IdModulo = new HashSet<PermisosPorModulo>();
            Permisos_IdPermiso = new HashSet<PermisosPorModulo>();
            Usuarios_Seg = new HashSet<Usuarios>();
            Usuarios_Rol = new HashSet<Usuarios>();
            GruposDetalles_Permiso = new HashSet<GruposDetalles>();
            GruposDetalles_Rol = new HashSet<GruposDetalles>();
        }

        [Key]
        public int IdGrupoDetalle { get; set; }

        public string Nombre { get; set; }

        public string Descripcion { get; set; }

        public int Orden { get; set; }

        public int IdGrupo { get; set; }

        public int? IdPadre { get; set; }

        public string Icono { get; set; }

        public string UrlDetalle { get; set; }

        public bool Estatus { get; set; }

        public DateTime FechaRegistro { get; set; }
        
        public virtual ICollection<GruposDetalles> ICollection { get; set; }

        public virtual GruposDetalles GruposDetallesR { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PermisosPorModulo> Permisos_IdModulo { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PermisosPorModulo> Permisos_IdPermiso { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Usuarios> Usuarios_Seg { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Usuarios> Usuarios_Rol { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<GruposDetalles> GruposDetalles_Permiso { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<GruposDetalles> GruposDetalles_Rol { get; set; }
    }
}
