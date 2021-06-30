locals {
  openldap = {
    version = "2.4.58"
  }
}

data "kustomization_overlay" "openldap" {
  count = var.ldap_enabled ? 1 : 0

  namespace = kubernetes_namespace.ldap[0].metadata[0].name

  resources = [
    "${path.module}/openldap"
  ]

  images {
    name = "docker.io/bitnami/openldap"
    new_tag = local.openldap.version
  }

  common_labels = {
    app = "openldap"
    version = local.openldap.version
  }

  depends_on = [
    kubernetes_secret.openldap
  ]
}

resource "kubernetes_secret" "openldap" {
  count = var.ldap_enabled ? 1 : 0

  metadata {
    name = "openldap"
    namespace = kubernetes_namespace.ldap[0].metadata[0].name
  }
  data = {
    adminpassword = "adminpassword"
    users = "user01,user02"
    passwords = "password01,password02"
  }
}

resource "kustomization_resource" "openldap" {
  for_each = data.kustomization_overlay.openldap[0].ids
  manifest = data.kustomization_overlay.openldap[0].manifests[each.value]
}

resource "kubernetes_namespace" "ldap" {
  count = var.ldap_enabled ? 1 : 0

  metadata {
    name = "ldap"
  }
}
