

This guide focuses on optimizing the first few minutes of your game, which are crucial for success. Effective onboarding and technical performance ensure players stay engaged rather than dropping off.

## 1. File Size and Loading

Technical performance is the first step toward accessibility. High-performing games load quickly even on older devices or slow connections.

### Keep it Small

Aim for a file size between **8MB and 10MB**. Reducing your build size ensures global reach.

[Godot: Optimizing for Size](https://docs.godotengine.org/en/stable/contributing/development/compiling/optimizing_for_size.html)

### Loading Screens

Use visually engaging loading bars that feature your logo or game visuals. This prevents players from thinking the game is frozen.

### Progressive Loading

Download only necessary files (main menu, first level) initially. Download the rest in the background while the player is occupied.

- **Watch:** [Kasper Mol’s presentation on Progressive Loading](https://www.youtube.com/embed/1odNKssL3Oc)
    

---

## 2. Onboarding Best Practices

Once the game loads, you need to get players into the action immediately.

- **Skip the Menu:** For first-time players, skip splash screens, title screens, and level selects.
    
    - _Example:_ [Monkey Mart](https://poki.com/en/g/monkey-mart)
        
- **Safe Beginner Environment:** Start with simple levels where players can't easily lose. This builds confidence and engagement.
    
    - _Example:_ [Subway Surfers](https://poki.com/en/g/subway-surfers) (Players can't die during the initial tutorial).
        

---

## 3. Effective Tutorials

Teach mechanics naturally without blocking gameplay.

- **Visual Explanation:** Use images, animations, or gestures instead of heavy text. This helps with international audiences and reduces "frontal load."
    
    - _Example:_ [Blumgi Slime](https://poki.com/en/g/blumgi-slime)
        
- **Gradual Introduction:** Introduce buttons and actions over several levels so players don't feel overwhelmed.
    
    - _Example:_ [Heart Star](https://poki.com/en/g/heart-star)
        

---

## 4. Mobile First

Mobile players make up a massive portion of the Poki audience.

- **Portrait vs. Landscape:** While both are supported, **Portrait mode** is highly recommended.
    
- **Benefits of Portrait:**
    
    - 6% more players enter gameplay on average.
        
    - Eligible for **Gamebar Display ads**, increasing revenue without extra development effort.
        

---

## 5. Test and Iterate

Use **Poki Playtest** recordings to watch how real players navigate your onboarding. Use these insights to fine-tune the experience and remove points of friction.

### Useful Developer Links
****
- [Poki Developer Blog](https://blog.poki.com/)