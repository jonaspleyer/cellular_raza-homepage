import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Arc, Circle, Rectangle
from matplotlib import rc, rc_context

# rcParams['path.sketch'] = (3, 10, 1)
rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
rc('text', usetex=True)
rc('font', size='20')

def plot_polygon_with_arrows(angle_circle_size = 0.8):
    fig, ax = plt.subplots(figsize=(8, 8))
    ax.axis('off')
    points = np.array([
        [0, 0],
        [1, 0.7],
        [2, 2.1],
        [3, 2.6],
        [4, 3.8],
        [5, 4.7],
    ])
    radius = 0.8
    cell_color = [0.9, 0.9, 0.9]
    for i in range(len(points)-1):
        p1 = points[i]
        p2 = points[i+1]
        c = p2 - p1
        angle = np.arccos(c[0] / np.linalg.norm(c))
        # direction = np.array([np.cos(np.pi / 2 + angle), np.sin(np.pi / 2 + angle)])
        direction = np.array([np.sin(angle), -np.cos(angle)])
        rect = Rectangle(
            points[i] + radius * direction,
            width=np.linalg.norm(c),
            height=2*radius,
            angle=angle / 2 / np.pi * 360,
            rotation_point='xy',
            color=cell_color,
        )
        ax.add_patch(rect)
        circle = Circle(points[i], radius, color=cell_color)
        ax.add_patch(circle)
    circle = Circle(points[-1], radius, color=cell_color)
    ax.add_patch(circle)

    ax.scatter(points[:,0], points[:,1], s=80, marker="+", color="k")
    ax.text(*(points[0] + np.array([-0.2,0.2])), "$\\vec v_{}$".format(0))
    ax.text(*(points[-1] + np.array([-0.2,0.2])), "$\\vec v_{}$".format(len(points)-1))
    with rc_context({'path.sketch': (4, 7, 1)}):
        ax.plot(points[:,0], points[:,1], color=[0.5, 0.5, 0.5], linewidth=1)

    # for i in range(len(points)-1):
    #     p1 = points[i]
    #     p2 = points[i+1]
    #     ax.arrow(
    #         *p1,
    #         *(p2-p1),
    #         head_width=0.1,
    #         edgecolor=[0.8, 0.8, 0.8],
    #         facecolor='none',
    #         length_includes_head=True,
    #     )

    for i in range(1, len(points)-1):
        p1 = points[i-1]
        p2 = points[i]
        p3 = points[i+1]
        c1 = p1-p2
        c2 = p3-p2

        perp = c1[0]*c2[1] - c1[1]*c2[0]
        alpha = np.arccos(np.dot(c2, np.array([1,0])) / np.linalg.norm(c2)) / 2 / np.pi * 360
        t = np.dot(c2, c1) / np.linalg.norm(c1) / np.linalg.norm(c2)
        theta2 = np.arccos(t) / 2 / np.pi * 360
        
        if perp > 0.0:
            alpha = 360 - theta2 + alpha
       
        a = (alpha + 0.5 * theta2) * 2 * np.pi / 360
        text_pos = np.array([
            0.25 * angle_circle_size * np.cos(np.pi + a),
            0.25 * angle_circle_size * np.sin(np.pi + a),
        ])
        ax.text(
            *(p2 + text_pos),
            "$\\vec v_{}$".format(i),
            verticalalignment='center',
            horizontalalignment='center',
        )
        ax.text(
            *(p2 - text_pos),
            "$\\alpha_{}$".format(i),
            verticalalignment='center',
            horizontalalignment='center',
        )

        arc = Arc(p2, angle_circle_size, angle_circle_size, angle=alpha, theta2=theta2)
        ax.add_patch(arc)
    ax.set_xlim(np.min(points[:,0])-radius, np.max(points[:,0])+radius)
    ax.set_ylim(np.min(points[:,1])-radius, np.max(points[:,1])+radius)
    fig.tight_layout()
    return fig, ax

if __name__ == "__main__":
    fig, ax = plot_polygon_with_arrows()
    fig.savefig("mechanics.png", transparent=True)
    plt.show()
