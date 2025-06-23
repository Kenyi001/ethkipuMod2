## TRABAJO FINAL - MÓDULO 2: Subasta Smart Contract

Este repositorio contiene el contrato inteligente de una subasta desplegado en la red Sepolia, acompañado de toda la documentación necesaria para su compilación, despliegue y uso.

---

### 📋 Contenido

1. [Requisitos](#requisitos)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Instalación y Configuración](#instalación-y-configuración)
4. [Compilación en Remix](#compilación-en-remix)
5. [Despliegue en Sepolia](#despliegue-en-sepolia)
6. [Verificación en Etherscan](#verificación-en-etherscan)
7. [Uso del Contrato](#uso-del-contrato)

   * Funciones principales
   * Eventos
   * Ejemplos de interacción con Web3
8. [Consideraciones Adicionales](#consideraciones-adicionales)
9. [Enlaces Útiles](#enlaces-útiles)

---

### 🛠 Requisitos

* **Node.js** (v14+)
* **MetaMask** configurado para la testnet Sepolia
* **ETH de prueba** en Sepolia (puedes obtenerlos desde un faucet)
* **Remix IDE** ([https://remix.ethereum.org/](https://remix.ethereum.org/))

---

### 📂 Estructura del Proyecto

```bash
├── contracts/
│   └── Auction.sol
├── README.md       ← Esta documentación
└── .gitignore
```

---

### ⚙️ Instalación y Configuración

1. Clona este repositorio:

   ```bash
   git clone https://github.com/TU_USUARIO/TU_REPOSITORIO.git
   cd TU_REPOSITORIO
   ```

2. Abre `https://remix.ethereum.org/`.
3. En el panel lateral, importa la carpeta entera del repositorio o sube `contracts/Auction.sol`.

---

### 🔨 Compilación en Remix

1. Selecciona la pestaña **Solidity Compiler**.
2. Configura la versión a **0.8.26** (o superior compatible).
3. Activa **Enable Optimization**, con **200 runs**.
4. Haz clic en **Compile Auction.sol**.


---

### 🚀 Despliegue en Sepolia

1. En **Deploy & Run Transactions**:
   - Environment: **Injected Web3** (tu MetaMask conectado a Sepolia)
   - Contract: `Auction`
   - Constructor Arguments:
     - `_durationMinutes`: duración de la subasta en minutos (p.ej. `60`).
     - `_startingBid`: puja inicial en wei (p.ej. `10000000000000000` para 0.01 ETH).
2. Haz clic en **Deploy**.
3. Confirma la transacción en MetaMask.
4. Copia la dirección del contrato desplegado.

---

### 🔍 Verificación en Etherscan

1. Ve a https://sepolia.etherscan.io/ y busca la dirección de tu contrato.
2. Haz clic en **Verify and Publish**.
3. Rellena:
   - Compiler: `Solidity (Single file)`
   - Version: `v0.8.26+commit...`
   - Optimization: **Yes**, 200 runs.
4. Pega el código completo de `Auction.sol`.
5. Envía y espera la confirmación.

---

### 💡 Uso del Contrato

#### Funciones principales

| Función      | Descripción                                                                                   |
| ------------ | --------------------------------------------------------------------------------------------- |
| `bid()`      | Hace una oferta. Debe superar en al menos 5 % la mejor oferta y enviarse antes de `endTime`. |
| `refund()`   | Permite retirar pujas anteriores (excepto la última oferta ganadora).                         |
| `endAuction()` | Finaliza la subasta cuando `block.timestamp >= endTime`, emite evento y transfiere fondos. |
| `getBids(address)` | Devuelve el arreglo de montos pujeados por una dirección.                                 |

#### Eventos

- `NewBid(address indexed bidder, uint amount)` — cada vez que se realiza una oferta.
- `AuctionEnded(address winner, uint amount)` — al finalizar la subasta.

#### Ejemplo con Web3.js

```js
const auction = new web3.eth.Contract(abi, CONTRACT_ADDRESS);

// Hacer oferta de 0.5 ETH
auction.methods.bid().send({ from: account, value: web3.utils.toWei('0.5', 'ether') });

// Finalizar subasta (solo tras expirar)
auction.methods.endAuction().send({ from: account });

// Escuchar evento NewBid
auction.events.NewBid({})
  .on('data', console.log);
````

---

### ⚠️ Consideraciones Adicionales

* Si una oferta válida llega en los últimos 10 min, `endTime` se extiende 10 min.
* Se descuenta una comisión fija del 2 % de la oferta ganadora.
* Emplea modificadores para control de acceso y validación de incrementos.

---

### 🔗 Enlaces Útiles

* Remix IDE: [https://remix.ethereum.org/](https://remix.ethereum.org/)
* Sepolia Faucet: [https://faucet.sepolia.dev/](https://faucet.sepolia.dev/)
* Sepolia Etherscan: [https://sepolia.etherscan.io/](https://sepolia.etherscan.io/)
* Documentación Web3.js: [https://web3js.readthedocs.io/](https://web3js.readthedocs.io/)

---

*¡Buena suerte en tu despliegue y que gane la mejor puja!*
