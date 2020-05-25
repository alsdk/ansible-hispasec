# Servicios

Instalar uno o varios servicios en la máquina. Uso:

```bash
ansible-playbook <nombre servicio>.yml -i <nombre inventario>,
```

Es importante definir el nombre del inventario, con el fin de no instalar por error el servicio en todas las máquinas.
La coma final es obligatoria. Es posible definir más de una máquina separándolas con comas.

Si la clave de root es necesaria:

```bash
ansible-playbook <nombre servicio>.yml -i <nombre inventario>, --become --ask-become-pass
```
