// MONEY HUD

const moneyHud = Vue.createApp({
    data() {
        return {
            cash: 0,
            bank: 0,
            amount: 0,
            plus: false,
            minus: false,
            showCash: false,
            showBank: false,
            showUpdate: false
        }
    },
    destroyed() {
        window.removeEventListener('message', this.listener);
    },
    mounted() {
        this.listener = window.addEventListener('message', (event) => {
            switch (event.data.action) {
                case 'showconstant':
                    this.showConstant(event.data)
                    break;
                case 'update':
                    this.update(event.data)
                    break;
                case 'show':
                    this.showAccounts(event.data)
                    break;
            }
        });
    },
    methods: {
        // CONFIGURE YOUR CURRENCY HERE
        // https://www.w3schools.com/tags/ref_language_codes.asp LANGUAGE CODES
        // https://www.w3schools.com/tags/ref_country_codes.asp COUNTRY CODES
        formatMoney(value) {
            const formatter = new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD',
                minimumFractionDigits: 0
            });
            return formatter.format(value);
        },
        showConstant(data) {
            this.showCash = true;
            this.showBank = true;
            this.cash = data.cash;
            this.bank = data.bank;
        },
        update(data) {
            this.showUpdate = true;
            this.amount = data.amount;
            this.bank = data.bank;
            this.cash = data.cash;
            this.minus = data.minus;
            this.plus = data.plus;
            if (data.type === 'cash') {
                if (data.minus) {
                    this.showCash = true;
                    this.minus = true;
                    setTimeout(() => this.showUpdate = false, 1000)
                    setTimeout(() => this.showCash = false, 2000)
                } else {
                    this.showCash = true;
                    this.plus = true;
                    setTimeout(() => this.showUpdate = false, 1000)
                    setTimeout(() => this.showCash = false, 2000)
                }
            }
            if (data.type === 'bank') {
                if (data.minus) {
                    this.showBank = true;
                    this.minus = true;
                    setTimeout(() => this.showUpdate = false, 1000)
                    setTimeout(() => this.showBank = false, 2000)
                } else {
                    this.showBank = true;
                    this.plus = true;
                    setTimeout(() => this.showUpdate = false, 1000)
                    setTimeout(() => this.showBank = false, 2000)
                }
            }
        },
        showAccounts(data) {
            if (data.type === 'cash' && !this.showCash) {
                this.showCash = true;
                this.cash = data.cash;
                setTimeout(() => this.showCash = false, 3500);
            }
            else if (data.type === 'bank' && !this.showBank) {
                this.showBank = true;
                this.bank = data.bank;
                setTimeout(() => this.showBank = false, 3500);
            }
        }
    }
}).mount('#money-container')

// PLAYER HUD

const playerHud = {
    data() {
        return {
            health: 0,
            armor: 0,
            hunger: 0,
            thirst: 0,
            stamina: 0,
            stress: 0,
            voice: 0,
            youhavemail: false,
            horsehealth: 0,
            horsestamina: 0,
            show: false,
            talking: false,
            showVoice: true,
            showHealth: true,
            showArmor: true,
            showHunger: true,
            showStamina: false,
            showThirst: true,
            showStress: true,
            showHorseStamina: false,
            showHorseHealth: false,
            showHorseStaminaColor: "#a16600",
            showHorseHealthColor: "#a16600",
            showYouHaveMail: true,
            talkingColor: "#FFFFFF",
        }
    },
    destroyed() {
        window.removeEventListener('message', this.listener);
    },
    mounted() {
        this.listener = window.addEventListener('message', (event) => {
            if (event.data.action === 'hudtick') {
                this.hudTick(event.data);
            }
        });
    },
    methods: {
        hudTick(data) {
            this.show = data.show;
            this.health = data.health;
            this.armor = data.armor;
            this.hunger = data.hunger;
            this.thirst = data.thirst;
            this.stress = data.stress;
            this.stamina = parseInt(data.stamina);
            this.voice = data.voice;
            this.youhavemail = data.youhavemail;
            this.talking = data.talking;
            this.showHorseStamina = data.onHorse;
            this.showHorseHealth = data.onHorse;
            if (data.onHorse) {
                this.horsehealth = data.horsehealth;
                this.horsestamina = data.horsestamina;
            }
            if (data.health >= 60) {
                this.showHealth = false;
            } else {
                this.showHealth = true;
            }
            if (data.health <= 30 ) {
              this.showHealthColor = "#FF0000";
            } else {
                this.showHealthColor = "#FFF";
            }
            if (data.hunger <= 30) {
                this.showHungerColor = "#FF0000";
            } else {
                this.showHungerColor = "#FFF";
            }
            if (data.thirst <= 30 ) {
                this.showThirstColor = "#FF0000";
            } else {
                this.showThirstColor = "#FFF";
            }

            this.showArmor = false;
            this.showStaminaColor = "#FFF";
    
            this.showHunger = true;
            this.showThirst = true;

            if (data.stress == 0) {
                this.showStress = false;
            } else {
                this.showStress = true;
            }
            if (parseInt(data.stamina) < 50) {
                this.showStamina = true;
            } else {
                this.showStamina = false;
            }

            if(parseInt(data.stamina) <= 20) {
                this.showStaminaColor = "#FF0000";
            }


            if (data.talking) {
                this.showVoice = true;
            } else {
                this.showVoice = false;
            }
            if (data.talking) {
                this.talkingColor = "#FF0000";
            } else {
                this.talkingColor = "#FFFFFF";
            }
            if (data.youhavemail) {
                this.showYouHaveMail = true;
            } else {
                this.showYouHaveMail = false;
            }
            if (data.youhavemail) {
                this.showYouHaveMailColor = "#FFD700";
            } else {
                this.showYouHaveMailColor = "#FFFFFF";
            }
        }
    }
}
const app = Vue.createApp(playerHud);
app.use(Quasar)
app.mount('#ui-container');
