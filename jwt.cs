using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

public class JwtTokenGenerator
{
    public static string GenerateToken(string secretKey, string issuer, string audience, int expireMinutes = 60)
    {
        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, "user_id_123"),
            new Claim(JwtRegisteredClaimNames.Email, "user@example.com"),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(expireMinutes),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public static void Main()
    {
        string secretKey = "YourSuperSecretKey123!"; // Should be 16+ chars
        string issuer = "your-app";
        string audience = "your-users";

        string token = GenerateToken(secretKey, issuer, audience);
        Console.WriteLine("Generated JWT Token:");
        Console.WriteLine(token);
    }
}