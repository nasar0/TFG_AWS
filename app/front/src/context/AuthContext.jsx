import React, { createContext, useState, useEffect } from 'react';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userEmail, setUserEmail] = useState('');
  const [idUser, setIdUser] = useState(0);
  const [cartCount, setCartCount] = useState(0); // Nuevo estado para el carrito

useEffect(() => {
  // 1. Miramos si el "seguro" de localStorage existe
  const storedIsAuthenticated = localStorage.getItem('isAuthenticated');

  if (storedIsAuthenticated === 'true') {
    // 2. Preguntamos al servidor
    fetch('/controlador/c-usuarios.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ action: "getSesion" ,email: localStorage.getItem('email') }),
      credentials: 'include', // <--- SIN ESTO, EL NAVEGADOR NO ENVÍA LA COOKIE
    })
    .then((response) => response.json())
    .then((data) => {
      // Aceptamos tanto 'id' como 'id_usuario' por si acaso
      const userId = data.id || data.id_usuario;
      
      if (data && userId && data.email) {
        setUserEmail(data.email);
        localStorage.setItem('email', data.email);
        setIdUser(userId);
        setIsAuthenticated(true);
      } else {
        localStorage.removeItem('isAuthenticated');
        setIsAuthenticated(false);
      }
    })
    .catch(() => setIsAuthenticated(false));
  }
}, []); // Los corchetes vacíos son clave para que se ejecute al cargar

  // Función para actualizar el contador del carrito
  const updateCartCount = () => {
    if (idUser > 0) {
      fetch('/controlador/c-usuarios.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        action: "n_carrito",
        id: idUser
      }),
      credentials: 'include'
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then((data) => {
        setCartCount(data)
      })
      .catch((error) => {
      });
    }
  };

  // Actualizar el carrito cuando cambie idUser
  useEffect(() => {
    updateCartCount();
  }, [idUser]);

  // useEffect(() => {
  //   const storedIsAuthenticated = localStorage.getItem('isAuthenticated');

  //   if (storedIsAuthenticated === 'true') {
  //     // Si la sesión está activa, hacemos una solicitud para obtener los datos del usuario
  //     fetch('/controlador/c-usuarios.php', {
  //       method: 'POST',
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: JSON.stringify({ action: "getSesion" }),
  //       credentials: 'include', // Asegura que las cookies se manden
  //     })
  //       .then((response) => response.json())
  //       .then((data) => {
  //         if (data.email) {
  //           setUserEmail(data.email);
  //           setIdUser(data.id);
  //           setIsAuthenticated(true);

  //         }
  //       })
  //       .catch((error) => {
  //         console.error("Error al cargar la sesión:", error);
  //       });
  //   }
  // }, []);

const login = (email) => {
   fetch('/controlador/c-usuarios.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ action: "listarEmail", email: email }),
    credentials: 'include',
  })
    .then((response) => response.json())
    .then((data) => {
      // Guardamos en el estado de React
      setIdUser(data.id_usuario);
      setUserEmail(email);
      setIsAuthenticated(true);
      localStorage.setItem('isAuthenticated', 'true');
      localStorage.setItem('email', email);

      // // CLAVE: Retornamos el segundo fetch para que la promesa espere al servidor
      // fetch('/controlador/c-usuarios.php', {
      //   method: 'POST',
      //   headers: { 'Content-Type': 'application/json' },
      //   body: JSON.stringify({ 
      //     action: "crearSesion", 
      //     email: email, 
      //     id: data.id_usuario 
      //   }),
      //   credentials: 'include',
      // });
    });

    return fetch('/controlador/c-usuarios.php', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ action: "getSesion", email: localStorage.getItem('email') }),
        credentials: 'include', // Asegura que las cookies se manden
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.email) {
            setUserEmail(data.email);
            setIdUser(data.id);
            setIsAuthenticated(true);
          }
        })
        .catch((error) => {
          console.error("Error al cargar la sesión:", error);
        });
};

  const logout = () => {
    // 1. Limpiar el estado ANTES de hacer la petición
    setIsAuthenticated(false);
    setUserEmail('');
    setIdUser(0);
    localStorage.removeItem('isAuthenticated');

    // 2. Luego hacer la petición al servidor
    fetch('/controlador/c-usuarios.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ action: "logout" }),
      credentials: 'include',
    }).catch(error => {
      console.error('Error al cerrar sesión:', error);
    });
  };

  return (
    <AuthContext.Provider 
      value={{ 
        isAuthenticated, 
        userEmail, 
        idUser, 
        cartCount,  // Exportar cartCount
        updateCartCount,  // Exportar función para actualizar
        login, 
        logout 
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};
